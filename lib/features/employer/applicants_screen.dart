import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../applications/domain/job_application.dart';
import '../jobs/domain/job.dart';
import '../jobs/presentation/job_badges.dart';
import '../jobs/presentation/job_card.dart';
import '../profile/domain/resume.dart';
import '../profile/resume_screen.dart';

class ApplicantsScreen extends StatefulWidget {
  const ApplicantsScreen({super.key, required this.job});
  final Job job;

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  ApplicationStatus? _filter;

  Future<void> _extend(Job job) async {
    final now = DateTime.now();
    final p = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (p != null) {
      await appState.updateJob(job.copyWith(deadline: DateTime(p.year, p.month, p.day, 23, 59)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final job = appState.jobById(widget.job.id) ?? widget.job;
        final all = appState.applicantsFor(job);
        final list = _filter == null ? all : all.where((a) => a.status == _filter).toList();
        return Scaffold(
          appBar: AppBar(title: Text(job.title), actions: [
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'toggle') {
                  appState.updateJob(job.copyWith(closed: !job.closed));
                } else {
                  _extend(job);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: 'toggle',
                    child: Text(job.closed ? 'Reopen applications' : 'Close applications')),
                const PopupMenuItem(value: 'extend', child: Text('Extend deadline')),
              ],
            ),
          ]),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(alignment: Alignment.centerLeft, child: JobMeta(job: job)),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                        label: const Text('All'),
                        selected: _filter == null,
                        onSelected: (_) => setState(() => _filter = null)),
                  ),
                  for (final s in ApplicationStatus.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                          label: Text(s.label),
                          selected: _filter == s,
                          onSelected: (_) => setState(() => _filter = s)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const EmptyState(
                      icon: Icons.people_outline,
                      title: 'No applicants here',
                      hint: 'Applications will appear here.')
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) => _ApplicantCard(a: list[i], job: job),
                    ),
            ),
          ]),
        );
      },
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  const _ApplicantCard({required this.a, required this.job});
  final JobApplication a;
  final Job job;

  @override
  Widget build(BuildContext context) {
    final withdrawn = a.status == ApplicationStatus.withdrawn;
    final r = a.resume;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(child: Text(a.applicantName[0])),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.applicantName, style: Theme.of(context).textTheme.titleMedium),
                Text(a.applicantEmail, style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            if (withdrawn)
              StatusChip(a.status)
            else
              PopupMenuButton<ApplicationStatus>(
                tooltip: 'Change status',
                onSelected: (s) => appState.setStatus(a, s),
                itemBuilder: (_) => [
                  for (final s in ApplicationStatus.values)
                    if (s != ApplicationStatus.withdrawn)
                      PopupMenuItem(value: s, child: Text(s.label)),
                ],
                child: StatusChip(a.status),
              ),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            Pill('${matchScore(r, job)}% match', Colors.blue, icon: Icons.auto_awesome),
            Pill('Applied ${timeAgo(a.date).toLowerCase()}', Colors.blueGrey, icon: Icons.schedule),
          ]),
          if (a.note.isNotEmpty) ...[const SizedBox(height: 8), Text(a.note)],
          if (r != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.description_outlined),
                label: const Text('View resume'),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ResumeView(resume: r),
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
