import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final Map<String, AppUser> _users = {
    'seeker@demo.com': const AppUser(name: 'Alex Morgan', email: 'seeker@demo.com', role: UserRole.seeker),
    'employer@demo.com': const AppUser(name: 'Techlogix', email: 'employer@demo.com', role: UserRole.employer),
  };
  final Map<String, String> _passwords = {
    'seeker@demo.com': '123456',
    'employer@demo.com': '123456',
  };

  @override
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final key = email.toLowerCase();
    if (_users[key] == null || _passwords[key] != password) {
      throw Exception('Incorrect email or password');
    }
    return _users[key]!;
  }

  @override
  Future<AppUser> register(String name, String email, String password, UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final key = email.toLowerCase();
    if (_users.containsKey(key)) throw Exception('An account with this email already exists');
    final user = AppUser(name: name, email: key, role: role);
    _users[key] = user;
    _passwords[key] = password;
    return user;
  }
}
