import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:gesture_memorize/global.dart';

abstract class CloudStorage {
  static final storageRef = FirebaseStorage.instance.ref();

  static Future<void> uploadGestureData(name) async {
    Map<String, dynamic> j = gestures.toJson();
    await storageRef.child("/$name.json").putString(jsonEncode(j));
  }
}