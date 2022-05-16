import 'package:shared_preferences/shared_preferences.dart';

enum PhysicalLevel { low, medium, high, extreme, none }

abstract class SessionKeyField {
  static const _sessionKey = 'level_key';
}

class SessionDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<PhysicalLevel> sessionLevel() async {
    var valueAsStr =
        (await _sharedPreferences).getString(SessionKeyField._sessionKey);
    return PhysicalLevel.values.firstWhere((e) => e.toString() == valueAsStr,
        orElse: () => PhysicalLevel.none);
  }

  Future<void> saveSessionLevel(PhysicalLevel value) async {
    (await _sharedPreferences)
        .setString(SessionKeyField._sessionKey, value.toString());
  }

  Future<void> clearSessionLevel() async {
    (await _sharedPreferences).remove(SessionKeyField._sessionKey);
  }
}
