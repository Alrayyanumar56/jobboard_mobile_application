import 'package:flutter/material.dart';
import '../../../state/app_state.dart';
import '../../notifications/notifications_screen.dart';
import '../../profile/domain/resume.dart';
import '../domain/job.dart';
import 'job_card.dart';
import 'job_details_screen.dart';

const jobTypes = ['Full-time', 'Part-time', 'Internship'];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Find your next job'), actions: [
          PopupMenuButton<JobSort>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            initialValue: appState.sort,
            onSelected: appState.setSort,
            itemBuilder: (_) => const [
              PopupMenuItem(value: JobSort.newest, child: Text('Newest')),
              PopupMenuItem(value: JobSort.bestMatch, child: Text('Best match')),
              PopupMenuItem(value: JobSort.deadline, child: Text('Closing soon')),
            ],
          ),
          const NotificationBell(),
        ]),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: appState.setQuery,
              decoration: InputDecoration(
                hintText: 'Search title, company or skill',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: const Text('Open only'),
                    selected: appState.openOnly,
                    onSelected: appState.setOpenOnly,
                  ),
                ),
                for (final t in jobTypes)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(t),
                      selected: appState.typeFilter == t,
                      onSelected: (s) => appState.setType(s ? t : null),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: _body(context)),
        ]),
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (appState.loading) return const Center(child: CircularProgressIndicator());
    if (appState.error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(appState.error!),
          const SizedBox(height: 12),
          FilledButton(onPressed: appState.load, child: const Text('Retry')),
        ]),
      );
    }
    final jobs = appState.jobs;
    if (jobs.isEmpty) {
      return const EmptyState(
          icon: Icons.search_off, title: 'No jobs found', hint: 'Try a different search or filter.');
    }
    final recs = appState.recommended;
    final showRecs = recs.isNotEmpty && appState.query.isEmpty && appState.typeFilter == null;
    final theme = Theme.of(context);
    return ListView(padding: const EdgeInsets.only(bottom: 16), children: [
      if (showRecs) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text('Recommended for you', style: theme.textTheme.titleMedium),
        ),
        SizedBox(
          height: 112,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [for (final j in recs) _RecCard(job: j)],
          ),
        ),
      ],
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text('All jobs (${jobs.length})', style: theme.textTheme.titleMedium),
      ),
      for (final j in jobs) JobCard(job: j),
    ]);
  }
}

class _RecCard extends StatelessWidget {
  const _RecCard({required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job))),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(job.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              Text(job.company, maxLines: 1, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Row(children: [
                const Icon(Icons.auto_awesome, size: 16),
                const SizedBox(width: 4),
                Text('${matchScore(appState.myResume, job)}% match'),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
