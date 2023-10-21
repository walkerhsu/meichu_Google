import 'package:gesture_memorize/data.dart';

class NoteCardInfo {
  NoteCardInfo._();

  static List<Map<String, dynamic>> notes = [];

  static Future<int> writeDefaultData() async {
    await Database.writeData("notes.json", {"notes": notes});
    return 1;
  }

  static Future<List<Map<String, dynamic>>> readData() async {
    try {
      Map<String, dynamic> data = await Database.readData("notes.json");
      notes = [];
      for (var i = 0; i < data["notes"].length; i++) {
        notes.add(data["notes"][i]);
      }
      return notes;
    } catch (e) {
      await writeDefaultData();
    }
    return notes;
  }

  static Future<int> writeData() async {
    await Database.writeData("notes.json", {"notes": notes});
    return 1;
  }

  static Future<int> addData(Map<String, dynamic> data) async {
    notes.add(data);
    await writeData();
    return 1;
  }

  static Future<int> editData(date, title, content) async {
    print(date);
    for (var i = 0; i < notes.length; i++) {
      if (notes[i]["date"] == date) {
        notes[i]["title"] = title;
        notes[i]["docs"] = content;
        break;
      }
    }
    await writeData();
    return 1;
  }

  static Future<int> deleteData(date) async {
    for (var i = 0; i < notes.length; i++) {
      if (notes[i]["date"] == date) {
        notes.removeAt(i);
        break;
      }
    }
    await writeData();
    return 1;
  }
}
