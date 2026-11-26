import '../../applications/domain/job_application.dart';
import '../../profile/domain/resume.dart';
import '../domain/job.dart';
import '../domain/job_repository.dart';
import 'mock_jobs.dart';

class MockJobRepository implements JobRepository {
  final List<Job> _jobs = List.of(mockJobs);
  late final List<JobApplication> _applications = _seed();

  Future<void> _delay([int ms = 500]) => Future.delayed(Duration(milliseconds: ms));

  /// Demo applicants so the employer side has something to show.
  List<JobApplication> _seed() {
    const people = [
      ('Sara Ahmed', 'sara@example.com', 'Flutter Developer', ['Flutter', 'Dart', 'Git']),
      ('Bilal Khan', 'bilal@example.com', 'Mobile Engineer', ['Flutter', 'Kotlin', 'REST']),
      ('Hira Malik', 'hira@example.com', 'Backend Developer', ['C#', 'SQL Server', 'ASP.NET Core']),
    ];
    final out = <JobApplication>[];
    for (final job in [mockJobs[0], mockJobs[1]]) {
      for (final (i, p) in people.indexed) {
        final (name, email, headline, skills) = p;
        final date = DateTime.now().subtract(Duration(days: i + 1));
        out.add(JobApplication(
          job: job,
          date: date,
          note: 'I would love to join ${job.company}.',
          applicantName: name,
          applicantEmail: email,
          resume: Resume(
            headline: headline,
            summary: 'Motivated engineer who enjoys building clean, reliable software.',
            education: 'BS Computer Science',
            experience: '2 years of professional experience.',
            skills: skills,
          ),
          history: [StatusEvent(ApplicationStatus.submitted, date)],
        ));
      }
    }
    return out;
  }

  @override
  Future<List<Job>> getJobs() async {
    await _delay(700);
    return List.of(_jobs);
  }

  @override
  Future<void> postJob(Job job) async {
    await _delay();
    _jobs.insert(0, job);
  }

  @override
  Future<void> updateJob(Job job) async {
    await _delay(300);
    final i = _jobs.indexWhere((j) => j.id == job.id);
    if (i != -1) _jobs[i] = job;
  }

  @override
  Future<List<JobApplication>> getApplications() async =>
      _applications.reversed.toList();

  @override
  Future<void> submitApplication(JobApplication application) async {
    await _delay();
    _applications.add(application);
  }

  @override
  Future<void> updateStatus(JobApplication application, ApplicationStatus status) async {
    await _delay(300);
    final i = _applications.indexOf(application);
    if (i != -1) _applications[i] = application.copyWith(status: status);
  }
}
