import 'package:flutter/material.dart';
import '../../../state/app_state.dart';
import '../domain/job.dart';
import 'job_details_screen.dart';

String timeAgo(DateTime d) {
  final days = DateTime.now().difference(d).inDays;
  if (days == 0) return 'Today';
  return days == 1 ? '1 day ago' : '$days days ago';
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.hint});
  final IconData icon;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(hint, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class JobList extends StatelessWidget {
  const JobList({super.key, required this.jobs, required this.emptyTitle, required this.emptyHint});
  final List<Job> jobs;
  final String emptyTitle;
  final String emptyHint;

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return EmptyState(icon: Icons.search_off, title: emptyTitle, hint: emptyHint);
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: jobs.length,
      itemBuilder: (_, i) => JobCard(job: jobs[i]),
    );
  }
}

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job))),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(radius: 24, child: Text(job.company[0])),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(job.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${job.company} • ${job.location}'),
                const SizedBox(height: 8),
                Text('${job.employmentType} • ${job.salary}', style: theme.textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(timeAgo(job.postedDate),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
              ]),
            ),
            IconButton(
              tooltip: 'Save job',
              icon: Icon(appState.isSaved(job) ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => appState.toggleSaved(job),
            ),
          ]),
        ),
      ),
    );
  }
}
