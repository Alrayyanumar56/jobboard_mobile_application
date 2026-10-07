import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const Center(child: CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44))),
          const SizedBox(height: 12),
          Center(child: Text('Alex Morgan', style: Theme.of(context).textTheme.titleLarge)),
          const Center(child: Text('alex@example.com')),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _Stat('Applied', appState.applications.length)),
            Expanded(child: _Stat('Saved', appState.savedJobs.length)),
          ]),
          const SizedBox(height: 16),
          const ListTile(leading: Icon(Icons.edit_outlined), title: Text('Edit profile')),
          const ListTile(leading: Icon(Icons.description_outlined), title: Text('Resume')),
          const ListTile(leading: Icon(Icons.notifications_outlined), title: Text('Notifications')),
          const ListTile(leading: Icon(Icons.logout), title: Text('Sign out')),
        ]),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(children: [
            Text('$value', style: Theme.of(context).textTheme.headlineSmall),
            Text(label),
          ]),
        ),
      );
}
