import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class Database {
  static Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> localFile(path) async {
    final local = await localPath();
    return File('$local/$path');
  }

  static Future<File> writeData(String path, Map<String, dynamic> data) async {
    final jsonData = jsonEncode(data);
    final file = await localFile(path);
    // Write the file
    return file.writeAsString(jsonData);
  }

  static Future<Map<String, dynamic>> readData(String path) async {
    try {
      final file = await localFile(path);
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return {};
    }
  }
}
