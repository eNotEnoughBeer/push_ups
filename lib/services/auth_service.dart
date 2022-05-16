import 'package:push_ups/providers/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();

  Future<bool> isAuth() async {
    return (await _sessionDataProvider.sessionLevel()) != PhysicalLevel.none;
  }

  Future<PhysicalLevel> authLevel() async {
    return (await _sessionDataProvider.sessionLevel());
  }

  Future<void> login(PhysicalLevel level) async {
    await _sessionDataProvider.saveSessionLevel(level);
  }

  Future<void> logout() async {
    await _sessionDataProvider.clearSessionLevel();
  }
}
