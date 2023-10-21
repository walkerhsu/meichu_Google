import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/global.dart';

class Function1Page extends StatefulWidget {
  const Function1Page({super.key});

  static String routeName = '/function1Page';
  @override
  State<Function1Page> createState() => _Function1PageState();
}

class _Function1PageState extends State<Function1Page> {
  reload() {
    setState(() {});
  }

  onArrowBackPressed() {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last['actions'].add({
        "name": "ArrowBack",
        "time": difference,
      });
      actions.add({
        "name": "ArrowBack",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.pushNamed(context, '/homePage');
  }

  @override
  Widget build(BuildContext context) {
    if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
        if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        }
        //NOTE - add any gestures here if needed
      });
    }
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is a function 1 page"),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavigation(reload: reload, root: "function1Page"),
    );
  }
}
