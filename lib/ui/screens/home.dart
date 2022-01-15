import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CountdownTimerController controller = CountdownTimerController(
      endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 60,
      onEnd: () {
        HapticFeedback.heavyImpact();
      });
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isRunning = controller.isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CountdownTimer(
          controller: controller,
          widgetBuilder: (_, CurrentRemainingTime? time) {
            if (time == null) {
              return Text('시간 종료');
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(' ${time.min ?? 0}분 ${time.sec} 초'),
                ]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isRunning ? Icons.stop : Icons.play_arrow),
        onPressed: () {
          if (controller.isRunning) {
            controller.disposeTimer();
            setState(() {
              isRunning = false;
            });
          } else {
            setState(() {
              isRunning = true;
            });
            controller.endTime =
                DateTime.now().millisecondsSinceEpoch + 1000 * 60 + 300;
            controller.start();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
