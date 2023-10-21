import 'package:flutter/material.dart';
import 'package:gesture_memorize/Gestures/gestures.dart';

Gestures gestures = Gestures(name: "test");
List actions = [];
bool recording = false;
bool playing = false;

onReturnHomePressed(context) {
  if (recording) {
    gestures.gestures.last.add({
      "name": "ReturnHome",
      "time": 3,
    });
  } else if (playing) {
    actions.removeAt(0);
  }
  Navigator.pushReplacementNamed(context, '/homePage');
}
