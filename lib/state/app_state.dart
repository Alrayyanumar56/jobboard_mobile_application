import 'package:flutter/foundation.dart';
import '../features/applications/domain/job_application.dart';
import '../features/jobs/data/mock_job_repository.dart';
import '../features/jobs/domain/job.dart';
import '../features/jobs/domain/job_repository.dart';

/// THE ONE LINE TO CHANGE when your API is ready:
/// replace MockJobRepository() with ApiJobRepository().
final appState = AppState(MockJobRepository());

class AppState extends ChangeNotifier {
  AppState(this._repo);
  final JobRepository _repo;

  List<Job> _jobs = [];
  List<JobApplication> applications = [];
  final Set<String> _saved = {};
  bool loading = true;
  String? error;
  String query = '';
  String? typeFilter;

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

  List<Job> get jobs {
    final q = query.toLowerCase();
    return _jobs.where((j) {
      final matches = q.isEmpty ||
          j.title.toLowerCase().contains(q) ||
          j.company.toLowerCase().contains(q) ||
          j.skills.any((s) => s.toLowerCase().contains(q));
      return matches && (typeFilter == null || j.employmentType == typeFilter);
    }).toList();
  }

  List<Job> get savedJobs => _jobs.where((j) => _saved.contains(j.id)).toList();
  bool isSaved(Job j) => _saved.contains(j.id);
  bool hasApplied(Job j) => applications.any((a) => a.job.id == j.id);

  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  void setType(String? t) {
    typeFilter = t;
    notifyListeners();
  }

  void toggleSaved(Job j) {
    if (!_saved.remove(j.id)) _saved.add(j.id);
    notifyListeners();
  }

  Future<void> apply(Job j, String note) async {
    await _repo.submitApplication(
        JobApplication(job: j, date: DateTime.now(), note: note));
    applications = await _repo.getApplications();
    notifyListeners();
  }
}
