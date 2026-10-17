import 'package:flutter/material.dart';
import '../features/applications/domain/job_application.dart';
import '../features/auth/data/mock_auth_repository.dart';
import '../features/auth/domain/app_user.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/jobs/data/mock_job_repository.dart';
import '../features/jobs/domain/job.dart';
import '../features/jobs/domain/job_repository.dart';
import '../features/notifications/domain/app_notification.dart';
import '../features/profile/domain/resume.dart';

/// THE ONLY PLACE TO CHANGE when your API is ready:
/// swap the two Mock repositories for ApiJobRepository / ApiAuthRepository.
final appState = AppState(MockJobRepository(), MockAuthRepository());

enum JobSort { newest, bestMatch, deadline }

class AppState extends ChangeNotifier {
  AppState(this._repo, this._auth);
  final JobRepository _repo;
  final AuthRepository _auth;

  AppUser? user;
  ThemeMode themeMode = ThemeMode.light;
  List<Job> _jobs = [];
  List<JobApplication> applications = [];
  final Set<String> _saved = {};
  final List<AppNotification> _notes = [];
  final Map<String, Resume> _resumes = {
    'seeker@demo.com': const Resume(
      headline: 'Flutter Developer',
      phone: '+92 300 0000000',
      location: 'Islamabad',
      summary: 'Software engineering student who loves building polished mobile apps.',
      education: 'BS Software Engineering',
      experience: 'Freelance mobile and web projects.',
      skills: ['Flutter', 'Dart', 'Git', 'REST'],
    ),
  };
  bool loading = true;
  String? error;
  String query = '';
  String? typeFilter;
  bool openOnly = false;
  JobSort sort = JobSort.newest;

  // ---- app-wide ----
  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // ---- auth ----
  Future<String?> login(String email, String password) =>
      _authenticate(() => _auth.login(email, password));

  Future<String?> register(String name, String email, String password, UserRole role) =>
      _authenticate(() => _auth.register(name, email, password, role));

  Future<String?> _authenticate(Future<AppUser> Function() action) async {
    try {
      user = await action();
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  void logout() {
    user = null;
    _saved.clear();
    query = '';
    typeFilter = null;
    openOnly = false;
    sort = JobSort.newest;
    notifyListeners();
  }

  // ---- data ----
  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      _jobs = await _repo.getJobs();
      applications = await _repo.getApplications();
    } catch (e) {
      error = 'Could not load jobs. Please try again.';
    }
    loading = false;
    notifyListeners();
  }

  Job? jobById(String id) {
    for (final j in _jobs) {
      if (j.id == id) return j;
    }
    return null;
  }

  Job jobOf(JobApplication a) => jobById(a.job.id) ?? a.job;

  int applicantCount(Job j) => applications
      .where((a) => a.job.id == j.id && a.status != ApplicationStatus.withdrawn)
      .length;

  JobAvailability availabilityOf(Job j) {
    if (j.closed) return JobAvailability.closed;
    final d = j.deadline;
    if (d != null && DateTime.now().isAfter(d)) return JobAvailability.expired;
    final max = j.maxApplicants;
    if (max != null && applicantCount(j) >= max) return JobAvailability.full;
    return JobAvailability.open;
  }

  // ---- notifications ----
  void _notify(String to, String title, String body) {
    _notes.add(AppNotification(toEmail: to, title: title, body: body, date: DateTime.now()));
  }

  List<AppNotification> get myNotifications =>
      _notes.where((n) => n.toEmail == user?.email).toList().reversed.toList();
  int get unreadCount =>
      _notes.where((n) => n.toEmail == user?.email && !n.read).length;

  void markAllRead() {
    for (final n in _notes) {
      if (n.toEmail == user?.email) n.read = true;
    }
    notifyListeners();
  }

  // ---- resume ----
  Resume? get myResume => _resumes[user?.email];

  void saveResume(Resume r) {
    final email = user?.email;
    if (email == null) return;
    _resumes[email] = r;
    notifyListeners();
  }

  // ---- job seeker ----
  List<Job> get jobs {
    final q = query.toLowerCase();
    final list = _jobs.where((j) {
      final matches = q.isEmpty ||
          j.title.toLowerCase().contains(q) ||
          j.company.toLowerCase().contains(q) ||
          j.skills.any((s) => s.toLowerCase().contains(q));
      final okType = typeFilter == null || j.employmentType == typeFilter;
      final okOpen = !openOnly || availabilityOf(j) == JobAvailability.open;
      return matches && okType && okOpen;
    }).toList();
    switch (sort) {
      case JobSort.newest:
        list.sort((a, b) => b.postedDate.compareTo(a.postedDate));
      case JobSort.bestMatch:
        list.sort((a, b) => matchScore(myResume, b).compareTo(matchScore(myResume, a)));
      case JobSort.deadline:
        list.sort((a, b) {
          final x = a.deadline, y = b.deadline;
          if (x == null && y == null) return 0;
          if (x == null) return 1;
          if (y == null) return -1;
          return x.compareTo(y);
        });
    }
    return list;
  }

  List<Job> get recommended {
    final list = _jobs
        .where((j) =>
            availabilityOf(j) == JobAvailability.open &&
            !hasApplied(j) &&
            matchScore(myResume, j) >= 50)
        .toList();
    list.sort((a, b) => matchScore(myResume, b).compareTo(matchScore(myResume, a)));
    return list.take(5).toList();
  }

  List<Job> get savedJobs => _jobs.where((j) => _saved.contains(j.id)).toList();
  List<JobApplication> get myApplications =>
      applications.where((a) => a.applicantEmail == user?.email).toList();

  JobApplication? activeApplicationFor(Job j) {
    for (final a in myApplications) {
      if (a.job.id == j.id && a.status != ApplicationStatus.withdrawn) return a;
    }
    return null;
  }

  bool isSaved(Job j) => _saved.contains(j.id);
  bool hasApplied(Job j) => activeApplicationFor(j) != null;

  JobApplication latest(JobApplication a) => applications.firstWhere(
        (x) =>
            x.job.id == a.job.id &&
            x.applicantEmail == a.applicantEmail &&
            x.date == a.date,
        orElse: () => a,
      );

  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  void setType(String? t) {
    typeFilter = t;
    notifyListeners();
  }

  void setOpenOnly(bool v) {
    openOnly = v;
    notifyListeners();
  }

  void setSort(JobSort s) {
    sort = s;
    notifyListeners();
  }

  void toggleSaved(Job j) {
    if (!_saved.remove(j.id)) _saved.add(j.id);
    notifyListeners();
  }

  Future<void> apply(Job j, String note) async {
    final now = DateTime.now();
    await _repo.submitApplication(JobApplication(
      job: j,
      date: now,
      note: note,
      applicantName: user?.name ?? 'Unknown',
      applicantEmail: user?.email ?? '',
      resume: myResume,
      history: [StatusEvent(ApplicationStatus.submitted, now)],
    ));
    applications = await _repo.getApplications();
    final owner = j.employerEmail;
    if (owner != null) {
      _notify(owner, 'New application', '${user?.name} applied for ${j.title}');
    }
    notifyListeners();
  }

  Future<void> withdraw(JobApplication a) async {
    await _repo.updateStatus(a, ApplicationStatus.withdrawn);
    applications = await _repo.getApplications();
    final owner = a.job.employerEmail;
    if (owner != null) {
      _notify(owner, 'Application withdrawn', '${a.applicantName} withdrew from ${a.job.title}');
    }
    notifyListeners();
  }

  // ---- employer ----
  List<Job> get myJobs => _jobs
      .where((j) => j.employerEmail != null && j.employerEmail == user?.email)
      .toList();

  List<JobApplication> applicantsFor(Job j) =>
      applications.where((a) => a.job.id == j.id).toList();

  Future<void> postJob(Job j) async {
    await _repo.postJob(j);
    _jobs = await _repo.getJobs();
    notifyListeners();
  }

  Future<void> updateJob(Job j) async {
    await _repo.updateJob(j);
    _jobs = await _repo.getJobs();
    notifyListeners();
  }

  Future<void> setStatus(JobApplication a, ApplicationStatus s) async {
    await _repo.updateStatus(a, s);
    applications = await _repo.getApplications();
    _notify(a.applicantEmail, 'Application update',
        'Your application for ${a.job.title} at ${a.job.company} is now ${s.label}.');
    notifyListeners();
  }
}
