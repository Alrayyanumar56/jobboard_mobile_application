import 'app_user.dart';

/// Throws Exception('message') on failure.
abstract class AuthRepository {
  Future<AppUser> login(String email, String password);
  Future<AppUser> register(String name, String email, String password, UserRole role);
}
