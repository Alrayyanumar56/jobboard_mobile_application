import 'package:flutter/material.dart';
import '../../../state/app_state.dart';
import '../domain/job.dart';

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
        final applied = appState.hasApplied(job);
        return Scaffold(
          appBar: AppBar(title: const Text('Job details'), actions: [
            IconButton(
              icon: Icon(appState.isSaved(job) ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => appState.toggleSaved(job),
            ),
          ]),
          body: ListView(padding: const EdgeInsets.all(20), children: [
            Text(job.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${job.company} • ${job.location}'),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              Chip(label: Text(job.employmentType)),
              Chip(label: Text(job.salary)),
            ]),
            _section(context, 'About the role', Text(job.description)),
            _section(
              context,
              'Requirements',
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (final r in job.requirements)
                  Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('• $r')),
              ]),
            ),
            _section(
              context,
              'Skills',
              Wrap(spacing: 8, runSpacing: 4, children: [
                for (final s in job.skills) Chip(label: Text(s)),
              ]),
            ),
          ]),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: applied
                    ? null
                    : () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => ApplySheet(job: job),
                        ),
                child: Text(applied ? 'Already applied' : 'Apply now'),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Apply to ${widget.job.company}', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(widget.job.title),
        const SizedBox(height: 16),
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
      ]),
    );
  }
}
