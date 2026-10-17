import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import 'employer_jobs_screen.dart';

class EmployerShell extends StatefulWidget {
  const EmployerShell({super.key});

  @override
  State<EmployerShell> createState() => _EmployerShellState();
}

class _EmployerShellState extends State<EmployerShell> {
  int _index = 0;
  static const _screens = [EmployerJobsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: 'My jobs'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
