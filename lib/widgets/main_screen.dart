import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_ups/services/training_cycle_service.dart';
import 'package:push_ups/view_model/main_screen_view_model.dart';
import 'package:push_ups/widgets/custom_timer_painter.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static Widget withProvider() {
    return ChangeNotifierProvider(
      create: (_) => ViewModel(),
      child: const MainScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ViewModel>();
    var currentWidget = _tasksList(model);
    switch (model.getCurTrainingCycle()) {
      case TrainingCycleType.none:
        currentWidget = _tasksList(model);
        break;
      case TrainingCycleType.pushUps:
        currentWidget = _pushUps(context, model);
        break;
      case TrainingCycleType.breakTimer:
        currentWidget = _coffeeBreak(context, model);
        break;
      case TrainingCycleType.done:
        currentWidget = _done(model);
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Тренеровка на ${model.tasks?.date}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => model.onLogoutPressed(context),
          ),
        ],
      ),
      body: currentWidget,
    );
  }

  Widget _tasksList(ViewModel model) {
    return SafeArea(
      child: ListView.separated(
        itemCount: model.tasks?.count ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: model.currentTask == index ? model.changeScreen : null,
            selected: model.currentTask == index,
            selectedColor: Colors.blueAccent,
            selectedTileColor: Colors.lightBlue[200],
            tileColor: model.currentTask > index
                ? Colors.green.shade200
                : Colors.black12,
            leading: model.currentTask > index
                ? const Icon(
                    Icons.done,
                    size: 50,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.play_circle_outline,
                    size: 50,
                    color: model.currentTask == index
                        ? Colors.blueAccent
                        : Colors.black26,
                  ),
            title: Text(
              'Задание ${index + 1}',
              style: TextStyle(
                fontSize: 25,
                color: model.currentTask > index
                    ? Colors.green.shade200
                    : Colors.black26,
              ),
            ),
            subtitle: Text(
                'Отжимания: ${model.tasks?.taskList?[index].pushUps.join('-')}',
                style: TextStyle(
                  fontSize: 18,
                  color: model.currentTask > index
                      ? Colors.green.shade200
                      : Colors.black26,
                )),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.black54,
            thickness: 1,
            height: 0,
          );
        },
      ),
    );
  }

  Widget _done(ViewModel model) {
    return SafeArea(
      child: FutureBuilder(
        future: model.taskDone(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white,
                    Colors.green.shade50,
                    Colors.green.shade100,
                  ],
                  stops: const [0.6, 0.8, 1.0],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 50.0,
                      child: CircleAvatar(
                        radius: 45,
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.green.shade200,
                        child: const Icon(
                          Icons.done,
                          size: 80,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const Text(
                      'Отлично!',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _coffeeBreak(BuildContext context, ViewModel model) {
    return SafeArea(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.white,
                Colors.blue.shade50,
                Colors.blue.shade100,
              ],
              stops: const [0.6, 0.8, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: CustomTimerPainter(
                                      valueInRange0_1: model.timerValue,
                                      backgroundColor: const Color(0xFF8D8D8D),
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Text(
                                    model.timerString,
                                    style: const TextStyle(
                                      fontSize: 112.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pushUps(BuildContext context, ViewModel model) {
    var fontSize =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.height / 2;
    return SafeArea(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.white,
                Colors.blue.shade50,
                Colors.blue.shade100,
              ],
              stops: const [0.6, 0.8, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  model.pushUpsLeft.toString(),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => model.decreasePushUps(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
