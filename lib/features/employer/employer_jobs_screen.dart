import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../jobs/domain/job.dart';
import '../jobs/presentation/job_badges.dart';
import '../jobs/presentation/job_card.dart';
import '../notifications/notifications_screen.dart';
import 'applicants_screen.dart';
import 'post_job_screen.dart';

class EmployerJobsScreen extends StatelessWidget {
  const EmployerJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final jobs = appState.myJobs;
        final open = jobs.where((j) => appState.availabilityOf(j) == JobAvailability.open).length;
        final applicants = jobs.fold<int>(0, (n, j) => n + appState.applicantCount(j));
        return Scaffold(
          appBar: AppBar(title: const Text('My job posts'), actions: const [NotificationBell()]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const PostJobScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Post job'),
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(children: [
                Expanded(child: StatCard('Open jobs', open)),
                Expanded(child: StatCard('Applicants', applicants)),
              ]),
            ),
            Expanded(
              child: jobs.isEmpty
                  ? const EmptyState(
                      icon: Icons.work_outline,
                      title: 'No jobs posted yet',
                      hint: 'Tap "Post job" to publish your first vacancy.')
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: jobs.length,
                      itemBuilder: (_, i) {
                        final job = jobs[i];
                        final count = appState.applicantCount(job);
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            title: Text(job.title),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${job.location} • ${job.employmentType}'),
                                Text('$count applicant${count == 1 ? '' : 's'}'),
                                const SizedBox(height: 6),
                                JobMeta(job: job),
                              ]),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ApplicantsScreen(job: job))),
                          ),
                        );
                      },
                    ),
            ),
          ]),
        );
      },
    );
  }
}
