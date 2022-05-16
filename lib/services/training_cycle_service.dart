import 'package:push_ups/json/task_for_today.dart';

enum TrainingCycleType { none, pushUps, breakTimer, done }

class TrainingCycle {
  var _trainingCycleType = TrainingCycleType.none;
  TrainingCycleType get trainingCycleType => _trainingCycleType;
  var _index = 0;
  int get index => _index;

  final OneTask? curTaskData;

  TrainingCycle({required this.curTaskData});

  void changeCycle() {
    if (curTaskData == null) return;
    switch (_trainingCycleType) {
      case TrainingCycleType.none:
        _trainingCycleType = TrainingCycleType.pushUps;
        break;
      case TrainingCycleType.pushUps:
        _trainingCycleType = _index < curTaskData!.breaks.length
            ? TrainingCycleType.breakTimer
            : _trainingCycleType = TrainingCycleType.done;
        break;
      case TrainingCycleType.breakTimer:
        _trainingCycleType = TrainingCycleType.pushUps;
        _index++;
        break;
      case TrainingCycleType.done:
        _trainingCycleType = TrainingCycleType.none;
        _index = 0;
        break;
    }
  }
}
