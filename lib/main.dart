import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'features/applications/applications_screen.dart';
import 'features/auth/domain/app_user.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/employer/employer_shell.dart';
import 'features/jobs/presentation/home_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/saved/saved_screen.dart';
import 'state/app_state.dart';

void main() {
  appState.load();
  runApp(const JobBoardApp());
}

class JobBoardApp extends StatelessWidget {
  const JobBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => MaterialApp(
        title: 'JobBoard',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        darkTheme: appDarkTheme,
        themeMode: appState.themeMode,
        home: const SplashGate(),
      ),
    );
  }
}

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return const AuthGate();
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.work, size: 72, color: cs.onPrimary),
          const SizedBox(height: 12),
          Text('JobBoard',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Find work. Hire talent.', style: TextStyle(color: cs.onPrimary)),
        ]),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final u = appState.user;
        if (u == null) return const LoginScreen();
        return u.role == UserRole.employer ? const EmployerShell() : const RootShell();
      },
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  static const _screens = [
    HomeScreen(),
    SavedScreen(),
    ApplicationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: 'Jobs'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Applications'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
