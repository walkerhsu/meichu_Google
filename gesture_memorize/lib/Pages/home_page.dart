import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
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

  onNotesPagePressed() {
    if (recording) {
      num difference = calculateTimeDifference();
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
    if (recording) {
      num difference = calculateTimeDifference();
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
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
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
              icon: const Icon(Icons.games_rounded)),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                onNotesPagePressed();
              },
              child: Image.asset(
                'assets/images/notebook.png',
                width: 100,
                height: 100,
              )
            ),
            const SizedBox(height: 100),
            InkWell(
              onTap: () {
                onMessagesPagePressed();
              },
              child: Image.asset(
                'assets/images/instagram.png',
                width: 100,
                height: 100,
              )
            ),
            const SizedBox(height: 100),
            InkWell(
              onTap: () {
                onMessagesPagePressed();
              },
              child: Image.asset(
                'assets/images/game-console.png',
                width: 100,
                height: 100,
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(reload: reload, root: "/homePage"),
    );
  }
}

// 