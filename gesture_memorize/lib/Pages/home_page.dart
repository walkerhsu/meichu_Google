import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/global.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = '/homePage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _time = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      setState(() {
        _time = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

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
    } else if (playing && actions.isNotEmpty) {
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
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    Navigator.of(context).pushNamed('/MessagesPage');
  }

  onGamePagePressed() {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "GamePage",
        "time": difference,
      });
      actions.add({
        "name": "GamePage",
        "time": difference,
      });
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    Navigator.of(context).pushNamed('/GamePage', arguments: {
      "count": count,
      "addCount": () {
        count += 1;
      },
      "rewardCount": () {
        count += 50;
      },
      "lastClaimTime": lastclaimtime,
      "updateClaimTime": () {
        lastclaimtime =
            DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
        if (!playing || actions.isEmpty) {
          playing = false;
          actions = [];
          reload();
        } else if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        } else if (actions[0]["name"] == "NotesPage") {
          onNotesPagePressed();
        } else if (actions[0]["name"] == "MessagesPage") {
          onMessagesPagePressed();
        } else if (actions[0]["name"] == "GamePage") {
          onGamePagePressed();
        }
        //NOTE - add any gestures here if needed
      });
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Column(children: <Widget>[
            const SizedBox(height: 100),
            Center(
              child: Text(
                DateFormat("hh:mm").format(_time),
                style: TextStyle(color: Colors.grey[200], fontSize: 75),
              ),
            ),
            Center(
              child: Text(
                DateFormat("MMM dd, EEEEEEEEE").format(_time),
                style: TextStyle(color: Colors.grey[200], fontSize: 15),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      onNotesPagePressed();
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/notebook.png',
                          width: 85,
                          height: 85,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Notes",
                          style:
                              TextStyle(color: Colors.grey[200], fontSize: 16),
                        )
                      ],
                    )),
                InkWell(
                    onTap: () {
                      onMessagesPagePressed();
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/message.png',
                          width: 85,
                          height: 85,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Messages",
                          style:
                              TextStyle(color: Colors.grey[200], fontSize: 16),
                        )
                      ],
                    )),
                InkWell(
                    onTap: () {
                      onGamePagePressed();
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/game-console.png',
                          width: 85,
                          height: 85,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Games",
                          style:
                              TextStyle(color: Colors.grey[200], fontSize: 16),
                        )
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 90),
          ])
        ],
      ),
      bottomNavigationBar: BottomNavigation(reload: reload, root: "/homePage"),
    );
  }
}

// 