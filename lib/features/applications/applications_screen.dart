import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../jobs/presentation/job_card.dart';
import '../jobs/presentation/job_details_screen.dart';
import 'domain/job_application.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  String _label(ApplicationStatus s) => '${s.name[0].toUpperCase()}${s.name.substring(1)}';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final apps = appState.applications;
        return Scaffold(
          appBar: AppBar(title: const Text('My applications')),
          body: apps.isEmpty
              ? const EmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'No applications yet',
                  hint: 'Jobs you apply to will appear here.',
                )
              : ListView.builder(
                  itemCount: apps.length,
                  itemBuilder: (_, i) {
                    final a = apps[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        leading: CircleAvatar(child: Text(a.job.company[0])),
                        title: Text(a.job.title),
                        subtitle: Text('${a.job.company}\nApplied ${timeAgo(a.date).toLowerCase()}'),
                        isThreeLine: true,
                        trailing: Chip(label: Text(_label(a.status))),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => JobDetailsScreen(job: a.job))),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
