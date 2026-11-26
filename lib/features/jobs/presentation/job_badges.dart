import 'package:flutter/material.dart';
import '../../../state/app_state.dart';
import '../../applications/domain/job_application.dart';
import '../../auth/domain/app_user.dart';
import '../../profile/domain/resume.dart';
import '../domain/job.dart';

String formatDate(DateTime d) {
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${d.day} ${m[d.month - 1]} ${d.year}';
}

String? deadlineText(Job j) {
  final d = j.deadline;
  if (d == null) return null;
  final left = d.difference(DateTime.now());
  if (left.isNegative) return 'Deadline passed';
  if (left.inHours < 24) return 'Closes in ${left.inHours}h';
  return 'Closes in ${left.inDays}d';
}

Color statusColor(ApplicationStatus s) => switch (s) {
      ApplicationStatus.submitted => Colors.blue,
      ApplicationStatus.reviewing => Colors.orange,
      ApplicationStatus.interview => Colors.green,
      ApplicationStatus.rejected => Colors.red,
      ApplicationStatus.withdrawn => Colors.grey,
    };

class Pill extends StatelessWidget {
  const Pill(this.text, this.color, {super.key, this.icon});
  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 4)],
          Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ]),
      );
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) => Pill(status.label, statusColor(status));
}

class StatCard extends StatelessWidget {
  const StatCard(this.label, this.value, {super.key});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Column(children: [
              Text('$value', style: Theme.of(context).textTheme.headlineSmall),
              Text(label),
            ]),
          ),
        ),
      );
}

/// Availability, deadline, spots left and resume-match badges for a job.
class JobMeta extends StatelessWidget {
  const JobMeta({super.key, required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    final av = appState.availabilityOf(job);
    final pills = <Widget>[];
    if (av == JobAvailability.closed) {
      pills.add(const Pill('Closed', Colors.grey, icon: Icons.lock_outline));
    } else if (av == JobAvailability.expired) {
      pills.add(const Pill('Deadline passed', Colors.red, icon: Icons.timer_off_outlined));
    } else if (av == JobAvailability.full) {
      pills.add(const Pill('Applicant limit reached', Colors.red, icon: Icons.group_off));
    } else {
      final t = deadlineText(job);
      if (t == null) {
        pills.add(const Pill('Open', Colors.green, icon: Icons.check_circle_outline));
      } else {
        final soon = job.deadline!.difference(DateTime.now()).inDays < 3;
        pills.add(Pill(t, soon ? Colors.orange : Colors.green, icon: Icons.schedule));
      }
    }
    final max = job.maxApplicants;
    if (max != null) {
      pills.add(Pill('${appState.applicantCount(job)}/$max spots filled', Colors.blueGrey,
          icon: Icons.people_outline));
    }
    final m = matchScore(appState.myResume, job);
    if (m > 0 && appState.user?.role == UserRole.seeker) {
      pills.add(Pill('$m% match', m >= 70 ? Colors.green : Colors.blue, icon: Icons.auto_awesome));
    }
    return Wrap(spacing: 6, runSpacing: 6, children: pills);
  }
}
