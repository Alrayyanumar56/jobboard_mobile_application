import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../auth/domain/app_user.dart';
import '../jobs/presentation/job_badges.dart';
import 'resume_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final u = appState.user;
        if (u == null) return const SizedBox();
        final employer = u.role == UserRole.employer;
        final r = appState.myResume;
        final pct = r?.completeness ?? 0;
        final applicants = appState.myJobs.fold<int>(0, (n, j) => n + appState.applicantCount(j));
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: ListView(padding: const EdgeInsets.all(20), children: [
            const Center(child: CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44))),
            const SizedBox(height: 12),
            Center(child: Text(u.name, style: Theme.of(context).textTheme.titleLarge)),
            Center(child: Text(u.email)),
            const SizedBox(height: 8),
            Center(child: Chip(label: Text(employer ? 'Employer' : 'Job seeker'))),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                  child: StatCard(employer ? 'Jobs posted' : 'Applied',
                      employer ? appState.myJobs.length : appState.myApplications.length)),
              Expanded(
                  child: StatCard(employer ? 'Applicants' : 'Saved',
                      employer ? applicants : appState.savedJobs.length)),
            ]),
            if (!employer)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(
                          child: Text('Resume completeness',
                              style: Theme.of(context).textTheme.titleSmall)),
                      Text('${(pct * 100).round()}%'),
                    ]),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: pct),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const ResumeScreen())),
                        child: Text(r == null ? 'Build resume' : 'Edit resume'),
                      ),
                    ),
                  ]),
                ),
              ),
            const Divider(height: 32),
            Text('Settings', style: Theme.of(context).textTheme.titleSmall),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark mode'),
              value: appState.themeMode == ThemeMode.dark,
              onChanged: (_) => appState.toggleTheme(),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'JobBoard',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.work, size: 40),
                children: const [Text('Find work. Hire talent.')],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: appState.logout,
            ),
          ]),
        );
      },
    );
  }
}
