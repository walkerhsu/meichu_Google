import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gesture_memorize/data.dart';

class ChatInfo {
  ChatInfo._();

  static List<Map<String, dynamic>> allchat = [];

  static Future<int> writeDefaultData(String path) async {
    final data = await rootBundle.loadString('assets/chat.json');
    final jsonData = jsonDecode(data);
    await Database.writeData(path, jsonData);
    return 1;
  }

  static Future<int> writeData() async {
    await Database.writeData("chat.json", {"allchat": allchat});
    return 1;
  }

  static Future<int> addData(Map<String, dynamic> data) async {
    print(data);
    allchat.add(data);
    await writeData();
    return 1;
  }

  static Future<List<Map<String, dynamic>>> readData(String path) async {
    try {
      Map<String, dynamic> data = await Database.readData(path);
      allchat = [];
      for (var i = 0; i < data["allchat"].length; i++) {
        allchat.add(data["allchat"][i]);
      }
      return allchat;
    } catch (e) {
      await writeDefaultData(path);
      return readData(path);
    }
  }


}
