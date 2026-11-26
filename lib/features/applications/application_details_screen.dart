import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../jobs/presentation/job_badges.dart';
import '../jobs/presentation/job_details_screen.dart';
import '../profile/resume_screen.dart';
import 'domain/job_application.dart';

class ApplicationDetailsScreen extends StatelessWidget {
  const ApplicationDetailsScreen({super.key, required this.application});
  final JobApplication application;

  Widget _section(BuildContext context, String title, Widget child) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          child,
        ]),
      );

  Future<void> _withdraw(BuildContext context, JobApplication a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Withdraw application?'),
        content: const Text('The employer will be notified. You can apply again later if the job is still open.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Withdraw')),
        ],
      ),
    );
    if (ok == true) await appState.withdraw(a);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final a = appState.latest(application);
        final job = appState.jobOf(a);
        final active = a.status != ApplicationStatus.rejected && a.status != ApplicationStatus.withdrawn;
        return Scaffold(
          appBar: AppBar(title: const Text('Application')),
          body: ListView(padding: const EdgeInsets.all(20), children: [
            Text(job.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${job.company} • ${job.location}'),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft, child: StatusChip(a.status)),
            _section(
              context,
              'Progress',
              Column(children: [
                for (final e in a.history)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.circle, size: 12, color: statusColor(e.status)),
                    title: Text(e.status.label),
                    subtitle: Text(formatDate(e.date)),
                  ),
              ]),
            ),
            if (a.note.isNotEmpty) _section(context, 'Cover note', Text(a.note)),
            if (a.resume != null) _section(context, 'Resume submitted', ResumeView(resume: a.resume!)),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job))),
              child: const Text('View job'),
            ),
            if (active)
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => _withdraw(context, a),
                child: const Text('Withdraw application'),
              ),
          ]),
        );
      },
    );
  }
}
