import 'package:flutter/material.dart';
import 'package:gesture_memorize/Gestures/gestures.dart';

Gestures currentGestures = Gestures(userName: "test");
List actions = [];
bool recording = false;
bool playing = false;

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
  }
  Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r)=>false);
}

num calculateTimeDifference () {
  num currentTime = DateTime.now().millisecondsSinceEpoch;
  num difference =
      currentTime - currentGestures.gestures.last['lastActionTime'];
  currentGestures.gestures.last['lastActionTime'] = currentTime;
  return difference;
}