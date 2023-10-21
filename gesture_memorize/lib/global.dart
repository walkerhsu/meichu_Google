import 'package:flutter/material.dart';
import 'package:gesture_memorize/Gestures/gestures.dart';
import 'package:intl/intl.dart';

Gestures currentGestures = Gestures(userName: "test");
List actions = [];
bool recording = false;
bool playing = false;
String initTime = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
String lastclaimtime =
    DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
int rewardInval = 10;

onReturnHomePressed(context) {
  if (recording) {
    num difference = calculateTimeDifference();
    currentGestures.gestures.last["actions"].add({
      "name": "ReturnHome",
      "time": difference,
    });
    actions.add({
      "name": "ReturnHome",
      "time": difference,
    });
  } else if (playing) {
    actions.removeAt(0);
  } else {
    playing = false;
    recording = false;
  }
  Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
}

num calculateTimeDifference() {
  num currentTime = DateTime.now().millisecondsSinceEpoch;
  num difference =
      currentTime - currentGestures.gestures.last['lastActionTime'];
  currentGestures.gestures.last['lastActionTime'] = currentTime;
  return difference;
}
