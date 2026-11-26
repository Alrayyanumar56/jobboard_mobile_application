class AppNotification {
  final String toEmail;
  final String title;
  final String body;
  final DateTime date;
  bool read;

  AppNotification({
    required this.toEmail,
    required this.title,
    required this.body,
    required this.date,
    this.read = false,
  });
}
