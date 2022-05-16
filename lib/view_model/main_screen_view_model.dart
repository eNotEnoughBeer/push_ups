import 'dart:async';

import 'package:flutter/material.dart';
import 'package:push_ups/json/task_for_today.dart';
import 'package:push_ups/network/http_api_client.dart';
import 'package:push_ups/providers/session_data_provider.dart';
import 'package:push_ups/providers/task_data_provider.dart';
import 'package:push_ups/services/auth_service.dart';
import 'package:push_ups/services/navigation.dart';
import 'package:push_ups/services/training_cycle_service.dart';

class ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _taskDataProvider = TaskDataProvider();
  TaskForToday? tasks;
  TrainingCycle? _trainingCycle;
  var level = PhysicalLevel.none;
  var currentTask = 0;
  var _pushUpsLeft = 999;
  int get pushUpsLeft => _pushUpsLeft;
  late AnimationController timerController;
  var timerValue = 1.0;

  ViewModel() {
    init();
  }

  Future<void> init() async {
    level = await _authService.authLevel();
    // читаем из сети задание на сегодня
    // т.к. в инет не лазим, и это заглушка, то тут есть switch
    // в реале просто в цункцию передается "level"
    final _httpApi = HttpApi();
    String assetsPath;
    switch (level) {
      case PhysicalLevel.low:
        assetsPath = 'assets/weak.json';
        break;
      case PhysicalLevel.medium:
        assetsPath = 'assets/normal.json';
        break;
      case PhysicalLevel.high:
        assetsPath = 'assets/strong.json';
        break;
      case PhysicalLevel.extreme:
        assetsPath = 'assets/extreme.json';
        break;
      case PhysicalLevel.none:
        assetsPath = 'ERROR. Check PhysicalLevel';
        break;
    }
    tasks = await _httpApi.fakeGet(assetsPath);

    // теперь проверка даты в shared_prefs и в tasks.
    var date = await _taskDataProvider.getDate();
    if (date != null) {
      if (date != tasks!.date) {
        // новый день.
        // удалить счетчик выполненных
        await _taskDataProvider.clearCurrentTask();
        // сохранить дату
        await _taskDataProvider.saveDate(tasks!.date);
      }
      // дата совпала. прочитать индекс выполненных заданий
      currentTask = await _taskDataProvider.getCurrentTask() ?? 0;
    } else {
      // вообще первый запуск для текущего уровня. даты нет. нада бы добавить
      await _taskDataProvider.saveDate(tasks!.date);
    }

    if (tasks != null) {
      if (tasks!.taskList != null) {
        _trainingCycle =
            TrainingCycle(curTaskData: tasks!.taskList![currentTask]);
      }
    }
    _trainingCycle ??= TrainingCycle(curTaskData: null);
    notifyListeners();
  }

  TrainingCycleType getCurTrainingCycle() {
    return _trainingCycle?.trainingCycleType ?? TrainingCycleType.none;
  }

  int getCurTrainingIndex() {
    return _trainingCycle?.index ?? 0;
  }

  double calcValueRange0_1(int value) {
    return value.toDouble() / getBreakTimeInSeconds();
  }

  String get timerString {
    var duration = Duration(seconds: getBreakTimeInSeconds()) * timerValue;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void changeScreen() {
    _trainingCycle?.changeCycle();
    if (getCurTrainingCycle() == TrainingCycleType.pushUps) {
      _pushUpsLeft =
          tasks?.taskList?[currentTask].pushUps[getCurTrainingIndex()] ?? 99;
      notifyListeners();
    }
    if (getCurTrainingCycle() == TrainingCycleType.breakTimer) {
      var totalTime = getBreakTimeInSeconds();
      timerValue = calcValueRange0_1(totalTime);
      notifyListeners();
      Timer.periodic(
        const Duration(seconds: 1),
        (Timer t) {
          if (totalTime == 0) {
            t.cancel();
            changeScreen();
          } else {
            timerValue = calcValueRange0_1(--totalTime);
            notifyListeners();
          }
        },
      );
    }
  }

  int getBreakTimeInSeconds() {
    var result =
        tasks?.taskList?[currentTask].breaks[getCurTrainingIndex()] ?? 0;
    return result * 60;
  }

  void decreasePushUps() {
    _pushUpsLeft--;
    if (_pushUpsLeft == 0) {
      changeScreen();
    }
    notifyListeners();
  }

  Future<void> taskDone() async {
    await _taskDataProvider.saveCurrentTask(++currentTask);
    _trainingCycle?.changeCycle();
    notifyListeners();
  }

  Future<void> onLogoutPressed(BuildContext context) async {
    await _authService.logout();
    await _taskDataProvider.clearDate();
    await _taskDataProvider.clearCurrentTask();
    Navigation.showAuthScreen(context);
  }
}
