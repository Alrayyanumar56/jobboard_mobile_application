enum UserRole { seeker, employer }

class AppUser {
  final String name;
  final String email;
  final UserRole role;
  const AppUser({required this.name, required this.email, required this.role});
}
