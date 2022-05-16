import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskKeyField {
  static const _dateKey = 'date';
  static const _currentTask = 'task_to_run';
}

class TaskDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<void> clearDate() async {
    (await _sharedPreferences).remove(TaskKeyField._dateKey);
  }

  Future<String?> getDate() async {
    return (await _sharedPreferences).getString(TaskKeyField._dateKey);
  }

  Future<void> saveDate(String value) async {
    (await _sharedPreferences)
        .setString(TaskKeyField._dateKey, value.toString());
  }

  Future<void> clearCurrentTask() async {
    (await _sharedPreferences).remove(TaskKeyField._currentTask);
  }

  Future<int?> getCurrentTask() async {
    return (await _sharedPreferences).getInt(TaskKeyField._currentTask);
  }

  Future<void> saveCurrentTask(int value) async {
    (await _sharedPreferences).setInt(TaskKeyField._currentTask, value);
  }
}
