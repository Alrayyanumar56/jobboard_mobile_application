import '../../applications/domain/job_application.dart';
import 'job.dart';

/// The app only talks to this interface. Later, an ApiJobRepository
/// implements it and replaces the mock one.
abstract class JobRepository {
  Future<List<Job>> getJobs();
  Future<void> postJob(Job job);
  Future<void> updateJob(Job job);
  Future<List<JobApplication>> getApplications();
  Future<void> submitApplication(JobApplication application);
  Future<void> updateStatus(JobApplication application, ApplicationStatus status);
}
