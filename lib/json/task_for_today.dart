import 'package:intl/intl.dart';

class OneTask {
  final List<int> pushUps;
  final List<int> breaks;
  OneTask({
    required this.pushUps,
    required this.breaks,
  });

  factory OneTask.fromJson(Map<String, dynamic> json) {
    return OneTask(
      pushUps: (json['push_ups'] as String).split('-').map(int.parse).toList(),
      breaks: (json['break'] as String).split('-').map(int.parse).toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'push_ups': pushUps.join('-'),
        'break': breaks.join('-'),
      };
}

class TaskForToday {
  final String date;
  final int? count;
  final List<OneTask>? taskList;

  TaskForToday({
    required this.date,
    required this.count,
    this.taskList,
  });

  factory TaskForToday.fromJson(Map<String, dynamic> json) {
    final size = json['count'] as int?;

    final now = DateTime.now();
    String formatter = DateFormat('yMd').format(now);

    if (size == null) {
      return TaskForToday(
        date: formatter, //json['date'] as String, // дату брать сегодняшнюю
        count: size,
      );
    } else {
      var list = <OneTask>[];
      for (int i = 1; i <= size; i++) {
        list.add(OneTask.fromJson(json['$i'] as Map<String, dynamic>));
      }
      return TaskForToday(
        date: formatter, //json['date'] as String,// дату брать сегодняшнюю
        count: size,
        taskList: list,
      );
    }
  }
}
