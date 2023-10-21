import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Constants/app_color.dart';
import 'package:gesture_memorize/global.dart';
import 'package:gesture_memorize/Infomations/note_card_info.dart';

class EditingPage extends StatefulWidget {
  const EditingPage({super.key});

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  String date = DateTime.now().toString();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();
  reload() {
    setState(() {});
  }

  onArrowBackPressed() async {
    await saveData();
    if (!mounted) return;
    if (recording) {
      print("arrowback");
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "ArrowBack",
        "time": difference,
      });
      actions.add({
        "name": "ArrowBack",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.pop(context);
  }

  Future<int> saveData() async {
    await NoteCardInfo.addData({
      "title": _titlecontroller.text,
      "docs": _contentcontroller.text,
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
        if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        }
        //NOTE - add any gestures here if needed
        if (actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed();
        }
      });
    }
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
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
                      await onArrowBackPressed();
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Text(date),
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
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      saveData().then((value) => Navigator.pop(context));
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNavigation(reload: reload, root: "editingPage"),
    );
  }
}
