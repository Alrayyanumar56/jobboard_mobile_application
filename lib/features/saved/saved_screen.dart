import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../jobs/presentation/job_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Saved jobs')),
        body: JobList(
          jobs: appState.savedJobs,
          emptyTitle: 'No saved jobs yet',
          emptyHint: 'Tap the bookmark on a job to save it here.',
        ),
      ),
    );
  }
}
