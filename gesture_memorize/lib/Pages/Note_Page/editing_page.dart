import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Constants/app_color.dart';
import 'package:gesture_memorize/global.dart';
import 'package:gesture_memorize/Infomations/note_card_info.dart';
import 'package:intl/intl.dart';

class EditingPage extends StatefulWidget {
  const EditingPage({super.key});

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  String date = DateTime.now().toString();
  final TextEditingController _titlecontroller =
      TextEditingController(text: "");
  final TextEditingController _contentcontroller =
      TextEditingController(text: "");
  reload() {
    if(mounted)
    {setState(() {});}
  }

  onArrowBackPressed(String title, String docs) async {
    if (recording) {
      num difference = calculateTimeDifference();
      if (difference >= 10000) difference = 10000;
      currentGestures.gestures.last["actions"].add({
        "name": "ArrowBack",
        "time": difference,
        "title": title,
        "docs": docs,
      });
      actions.add({
        "name": "ArrowBack",
        "time": difference,
        "title": title,
        "docs": docs,
      });
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    await saveData(title, docs);
    if (!mounted) return;
    Navigator.pop(context);
  }

  onTitleEdittingCompleted() {
    if (recording) {
      num difference = calculateTimeDifference();
      if (difference >= 2000) difference = 2000;
      currentGestures.gestures.last["actions"].add({
        "name": "TitleEdittingCompleted",
        "time": difference,
        "title": _titlecontroller.text,
        "content": _contentcontroller.text,
      });
      actions.add({
        "name": "TitleEdittingCompleted",
        "time": difference,
        "title": _titlecontroller.text,
        "content": _contentcontroller.text,
      });
    } else if (playing && actions.isNotEmpty) {
      // print(actions[0]["title"]);
      _titlecontroller.text = actions[0]["title"] ?? "";
      _contentcontroller.text = actions[0]["content"] ?? "";
      actions.removeAt(0);
      reload();
    }
  }

  onContentEdittingCompleted() {
    if (recording) {
      num difference = calculateTimeDifference();
      if (difference >= 2000) difference = 2000;
      currentGestures.gestures.last["actions"].add({
        "name": "ContentEdittingCompleted",
        "time": difference,
        "title": _titlecontroller.text,
        "content": _contentcontroller.text,
      });
      actions.add({
        "name": "ContentEdittingCompleted",
        "time": difference,
        "title": _titlecontroller.text,
        "content": _contentcontroller.text,
      });
    } else if (playing && actions.isNotEmpty) {
      _titlecontroller.text = actions[0]["title"] ?? "";
      _contentcontroller.text = actions[0]["content"] ?? "";
      actions.removeAt(0);
      reload();
    }
  }

  Future<int> saveData(String title, String docs) async {
    await NoteCardInfo.addData({
      "title": title,
      "docs": docs,
      "date": date,
    });
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    if (playing && actions.isEmpty) {
      playing = false;
      reload();
    } else if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
        if (!playing || actions.isEmpty) {
          playing = false;
          actions = [];
          reload();
        } else if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        } else if (actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed(
              actions[0]["title"] ?? "", actions[0]["docs"] ?? "");
        } else if (actions[0]["name"] == "TitleEdittingCompleted") {
          onTitleEdittingCompleted();
        } else if (actions[0]["name"] == "ContentEdittingCompleted") {
          onContentEdittingCompleted();
        }
        //NOTE - add any gestures here if needed
      });
    }
    return Scaffold(
      backgroundColor: AppColor.almond,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    iconSize: 20,
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await onArrowBackPressed(
                          _titlecontroller.text, _contentcontroller.text);
                    },
                  ),
                  const Icon(Icons.new_releases_rounded, color: Colors.white),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  const BigText(
                      text: 'N E W  N O T E S',
                      fontColor: Colors.white,
                      size: 20.0),
                ],
              ),
              TextField(
                controller: _titlecontroller,
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                ),
                onSubmitted: onTitleEdittingCompleted(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Text(
                  'Created At: ${DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse(date))}'),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              TextField(
                controller: _contentcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Note Description',
                ),
                onSubmitted: onContentEdittingCompleted(),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await onArrowBackPressed(
                          _titlecontroller.text, _contentcontroller.text);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        reload: reload,
        root: "editingPage",
        bgcolor: const Color.fromARGB(255, 228, 215, 194),
      ),
    );
  }
}
