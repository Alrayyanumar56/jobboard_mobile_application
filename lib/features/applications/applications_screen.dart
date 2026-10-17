import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../jobs/presentation/job_badges.dart';
import '../jobs/presentation/job_card.dart';
import 'application_details_screen.dart';
import 'domain/job_application.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  String _filter = 'All';

  bool _match(ApplicationStatus s) {
    final closed = s == ApplicationStatus.rejected || s == ApplicationStatus.withdrawn;
    if (_filter == 'Active') return !closed;
    if (_filter == 'Closed') return closed;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final apps = appState.myApplications.where((a) => _match(a.status)).toList();
        return Scaffold(
          appBar: AppBar(title: const Text('My applications')),
          body: Column(children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final f in ['All', 'Active', 'Closed'])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: _filter == f,
                        onSelected: (_) => setState(() => _filter = f),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: apps.isEmpty
                  ? const EmptyState(
                      icon: Icons.assignment_outlined,
                      title: 'No applications here',
                      hint: 'Jobs you apply to will appear here.')
                  : ListView.builder(
                      itemCount: apps.length,
                      itemBuilder: (_, i) {
                        final a = apps[i];
                        final job = appState.jobOf(a);
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            leading: CircleAvatar(child: Text(job.company[0])),
                            title: Text(job.title),
                            subtitle: Text('${job.company}\nApplied ${timeAgo(a.date).toLowerCase()}'),
                            isThreeLine: true,
                            trailing: StatusChip(a.status),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ApplicationDetailsScreen(application: a))),
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
