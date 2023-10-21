import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/bottom_navigation.dart';
import 'package:gesture_memorize/Pages/game.dart';
import 'package:gesture_memorize/global.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = '/homePage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String time = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
  int _count = 0;

  reload() {
    setState(() {});
  }

  onFunction1Pressed() {
    if (recording) {
      num difference = calculateTimeDifference();
      actions.add({
        "name": "function1",
        "time": difference,
      });
      currentGestures.gestures.last['actions'].add({
        "name": "function1",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.of(context).pushNamed(
      '/function1Page',
    );
  }

  onFunction2Pressed() {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last['actions'].add({
        "name": "function2",
        "time": difference,
      });
      actions.add({
        "name": "function2",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.of(context).pushNamed('/function2Page');
  }

  onNotesPagePressed() {
    num difference = calculateTimeDifference();
    if (recording) {
      currentGestures.gestures.last["actions"].add({
        "name": "NotesPage",
        "time": difference,
      });
      actions.add({
        "name": "NotesPage",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.of(context).pushNamed('/NotesPage');
  }

  onMessagesPagePressed() {
    num difference = calculateTimeDifference();
    if (recording) {
      currentGestures.gestures.last["actions"].add({
        "name": "MessagesPage",
        "time": difference,
      });
      actions.add({
        "name": "MessagesPage",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.of(context).pushNamed('/MessagesPage');
  }

  @override
  Widget build(BuildContext context) {
    if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(seconds: actions[0]["time"]), () {
        if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        } else if (actions[0]["name"] == "NotesPage") {
          onNotesPagePressed();
        } else if (actions[0]["name"] == "MessagesPage") {
          onMessagesPagePressed();
        }
        //NOTE - add any gestures here if needed
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("HomePage"),
        actions: <Widget>[
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, GamePage.routeName, arguments: {
                    "time": time,
                    "count": _count,
                    "addCount": () {
                      _count += 1;
                    }
                  }),
              icon: Icon(Icons.games_rounded)),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                onNotesPagePressed();
              },
              icon: const Icon(
                Icons.accessibility,
                size: 100,
              ),
            ),
            const SizedBox(height: 100),
            IconButton(
              onPressed: () {
                onMessagesPagePressed();
              },
              icon: const Icon(
                Icons.accessibility,
                size: 100,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(reload: reload, root: "homePage"),
    );
  }
}

// 