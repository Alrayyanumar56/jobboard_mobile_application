import '../../jobs/domain/job.dart';
import '../../profile/domain/resume.dart';

enum ApplicationStatus { submitted, reviewing, interview, rejected, withdrawn }

extension ApplicationStatusLabel on ApplicationStatus {
  String get label => '${name[0].toUpperCase()}${name.substring(1)}';
}

class StatusEvent {
  final ApplicationStatus status;
  final DateTime date;
  const StatusEvent(this.status, this.date);
}

class JobApplication {
  final Job job;
  final DateTime date;
  final String note;
  final String applicantName;
  final String applicantEmail;
  final Resume? resume;
  final ApplicationStatus status;
  final List<StatusEvent> history;

  const JobApplication({
    required this.job,
    required this.date,
    required this.note,
    required this.applicantName,
    required this.applicantEmail,
    this.resume,
    this.status = ApplicationStatus.submitted,
    this.history = const [],
  });

  JobApplication copyWith({ApplicationStatus? status}) {
    final s = status ?? this.status;
    return JobApplication(
      job: job,
      date: date,
      note: note,
      applicantName: applicantName,
      applicantEmail: applicantEmail,
      resume: resume,
      status: s,
      history: [...history, StatusEvent(s, DateTime.now())],
    );
  }
}
