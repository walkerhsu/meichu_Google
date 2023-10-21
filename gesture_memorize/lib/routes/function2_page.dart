import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/bottom_navigation.dart';
import 'package:gesture_memorize/global.dart';

class Function2Page extends StatefulWidget {
  const Function2Page({super.key});

  static String routeName = '/function2Page';
  @override
  State<Function2Page> createState() => _Function2PageState();
}

class _Function2PageState extends State<Function2Page> {
  reload() {
    setState(() {
      
    });
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
    } else {
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
    return  Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is a function 2 page"),
          ],
        ),
      ),
      bottomNavigationBar:  BottomNavigation(reload: reload, root: "function2Page"),
    );
  }
}
