import '../../applications/domain/job_application.dart';
import '../domain/job.dart';
import '../domain/job_repository.dart';
import 'mock_jobs.dart';

class MockJobRepository implements JobRepository {
  final List<JobApplication> _applications = [];

  @override
  Future<List<Job>> getJobs() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return mockJobs;
  }

  @override
  Future<List<JobApplication>> getApplications() async =>
      _applications.reversed.toList();

  @override
  Future<void> submitApplication(JobApplication application) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _applications.add(application);
  }
}
