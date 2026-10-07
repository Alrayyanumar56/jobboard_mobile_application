import '../../jobs/domain/job.dart';

enum ApplicationStatus { submitted, reviewing, interview, rejected }

class JobApplication {
  final Job job;
  final DateTime date;
  final String note;
  final ApplicationStatus status;

  const JobApplication({
    required this.job,
    required this.date,
    required this.note,
    this.status = ApplicationStatus.submitted,
  });
}
