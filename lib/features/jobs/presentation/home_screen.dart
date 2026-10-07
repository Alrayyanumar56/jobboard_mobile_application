import 'package:flutter/material.dart';
import '../../../state/app_state.dart';
import 'job_card.dart';

const jobTypes = ['Full-time', 'Part-time', 'Internship'];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Find your next job')),
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
          Expanded(child: _body()),
        ]),
      ),
    );
  }

  Widget _body() {
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
    return JobList(
      jobs: appState.jobs,
      emptyTitle: 'No jobs found',
      emptyHint: 'Try a different search or filter.',
    );
  }
}
