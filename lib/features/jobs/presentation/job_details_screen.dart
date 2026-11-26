import 'package:flutter/material.dart';
import '../../../state/app_state.dart';
import '../../applications/domain/job_application.dart';
import '../../profile/domain/resume.dart';
import '../../profile/resume_screen.dart';
import '../domain/job.dart';
import 'job_badges.dart';
import 'job_card.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key, required this.job});
  final Job job;

  Widget _section(BuildContext context, String title, Widget child) => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          child,
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final j = appState.jobById(job.id) ?? job;
        final av = appState.availabilityOf(j);
        final existing = appState.activeApplicationFor(j);
        final canApply = existing == null && av == JobAvailability.open;
        final label = existing != null
            ? 'Applied: ${existing.status.label}'
            : switch (av) {
                JobAvailability.open => 'Apply now',
                JobAvailability.closed => 'Applications closed',
                JobAvailability.expired => 'Deadline passed',
                JobAvailability.full => 'Applicant limit reached',
              };
        return Scaffold(
          appBar: AppBar(title: const Text('Job details'), actions: [
            IconButton(
              icon: Icon(appState.isSaved(j) ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => appState.toggleSaved(j),
            ),
          ]),
          body: ListView(padding: const EdgeInsets.all(20), children: [
            Text(j.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${j.company} • ${j.location}'),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              Chip(label: Text(j.employmentType)),
              Chip(label: Text(j.salary)),
            ]),
            const SizedBox(height: 8),
            JobMeta(job: j),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Posted ${formatDate(j.postedDate)} (${timeAgo(j.postedDate).toLowerCase()})',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (j.deadline != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Apply before ${formatDate(j.deadline!)}'),
              ),
            _section(context, 'About the role', Text(j.description)),
            _section(
              context,
              'Requirements',
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (final r in j.requirements)
                  Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('• $r')),
              ]),
            ),
            _section(
              context,
              'Skills',
              Wrap(spacing: 8, runSpacing: 4, children: [
                for (final s in j.skills) Chip(label: Text(s)),
              ]),
            ),
          ]),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: canApply
                    ? () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => ApplySheet(job: j),
                        )
                    : null,
                child: Text(label),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ApplySheet extends StatefulWidget {
  const ApplySheet({super.key, required this.job});
  final Job job;

  @override
  State<ApplySheet> createState() => _ApplySheetState();
}

class _ApplySheetState extends State<ApplySheet> {
  final _note = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    await appState.apply(widget.job, _note.text.trim());
    nav.pop();
    messenger.showSnackBar(const SnackBar(content: Text('Application submitted')));
  }

  @override
  Widget build(BuildContext context) {
    final r = appState.myResume;
    final theme = Theme.of(context);
    final ready = r != null && r.isComplete;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Apply to ${widget.job.company}', style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(widget.job.title),
        const SizedBox(height: 16),
        if (!ready) ...[
          const Text('Add your resume first. Employers need your headline, summary and skills.'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final nav = Navigator.of(context);
                nav.pop();
                nav.push(MaterialPageRoute(builder: (_) => const ResumeScreen()));
              },
              child: const Text('Build my resume'),
            ),
          ),
        ] else ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(r.headline),
              subtitle: Text('Resume attached • ${matchScore(r, widget.job)}% match'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Cover note (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(_busy ? 'Submitting...' : 'Submit application'),
            ),
          ),
        ],
      ]),
    );
  }
}
