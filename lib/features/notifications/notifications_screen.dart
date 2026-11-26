import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../jobs/presentation/job_card.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final n = appState.unreadCount;
        return IconButton(
          tooltip: 'Notifications',
          icon: Badge(
            isLabelVisible: n > 0,
            label: Text('$n'),
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
        );
      },
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final list = appState.myNotifications;
        return Scaffold(
          appBar: AppBar(title: const Text('Notifications'), actions: [
            TextButton(onPressed: appState.markAllRead, child: const Text('Mark all read')),
          ]),
          body: list.isEmpty
              ? const EmptyState(
                  icon: Icons.notifications_none,
                  title: 'Nothing yet',
                  hint: 'Updates about your applications will show up here.')
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final n = list[i];
                    return ListTile(
                      leading: Icon(n.read ? Icons.notifications_none : Icons.notifications_active),
                      title: Text(n.title,
                          style: TextStyle(fontWeight: n.read ? FontWeight.normal : FontWeight.bold)),
                      subtitle: Text('${n.body}\n${timeAgo(n.date)}'),
                      isThreeLine: true,
                    );
                  },
                ),
        );
      },
    );
  }
}
