import 'package:flutter/material.dart';
import 'package:gesture_memorize/Gestures/gestures.dart';

Gestures currentGestures = Gestures(userName: "test");
List actions = [];
bool recording = false;
bool playing = false;

onReturnHomePressed(context) {
  if (recording) {
    currentGestures.gestures.last["actions"].add({
      "name": "ReturnHome",
      "time": 3,
    });
  } else if (playing) {
    actions.removeAt(0);
  }
  Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r)=>false);
}
