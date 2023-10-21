import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
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

  late final String time;
  final TextEditingController _titlecontroller =
      TextEditingController(text: "");
  final TextEditingController _contentcontroller =
      TextEditingController(text: "");
  reload() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    time = DateFormat("MMM dd, yy hh:mm").format(DateTime.parse(date));
  }

  Timer? timer;

  onArrowBackPressed(String title, String docs, String time) async {
    if (recording) {
      num difference = calculateTimeDifference();
      if (difference >= 10000) difference = 10000;
      currentGestures.gestures.last["actions"].add({
        "name": "ArrowBack",
        "time": difference,
        "title": title,
        "docs": docs,
        "createTime": time,
      });
      actions.add({
        "name": "ArrowBack",
        "time": difference,
        "title": title,
        "docs": docs,
        "createTime": time,
      });
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    await saveData(title, docs, time);
    if (!mounted) return;
    print(actions);
    timer?.cancel();
    Navigator.pop(context);
  }

  onContentEdittingCompleted() {
    if (recording) {
      num difference = calculateTimeDifference();
      if (difference >= 2000) difference = 2000;
      currentGestures.gestures.last["actions"].add({
        "name": "ContentEdittingCompleted",
        "time": difference,
        "title": _contentcontroller.text,
        "content": _contentcontroller.text,
      });
      actions.add({
        "name": "ContentEdittingCompleted",
        "time": difference,
        "title": _contentcontroller.text,
        "content": _contentcontroller.text,
      });
    } else if (playing && actions.isNotEmpty) {
      print(actions[0]["content"]);
      _contentcontroller.text = actions[0]["content"] ?? "";
      actions.removeAt(0);
      reload();
    }
  }

  Future<int> saveData(String title, String docs, String time) async {
    await NoteCardInfo.addData({
      "title": docs,
      "docs": docs,
      "date": date,
      "time": time,
    });
    return 1;
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _contentcontroller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (playing && actions.isEmpty) {
      playing = false;
      reload();
    } else if (playing && actions.isNotEmpty) {
      timer?.cancel();
      timer = Timer(Duration(milliseconds: actions[0]["time"]), () {
        if (!playing || actions.isEmpty) {
          playing = false;
          actions = [];
          reload();
        } else if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        } else if (actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed(
              actions[0]["title"] ?? _contentcontroller.text ?? "",
              actions[0]["docs"] ?? _contentcontroller.text ?? "",
              actions[0]["createTime"] ?? "");
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
              SizedBox(
                width: screenWidth,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColor.chocolate,
                      ),
                      onPressed: () {
                        onArrowBackPressed(_titlecontroller.text,
                            _contentcontroller.text, time);
                        // Navigator.pop(context);
                      },
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          const BigText(
                              text: 'N E W  N O T E S',
                              fontColor: AppColor.chocolate,
                              size: 20.0),
                          const Spacer(),
                          SmallText(
                            text: time,
                            fontColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    // const Icon(Icons.new_releases_rounded, color: Colors.white),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 30,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: screenWidth / 30),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: Container(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 30),
                        child: TextField(
                          controller: _contentcontroller,
                          onSubmitted: onContentEdittingCompleted(),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'write something here...',
                          ),
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 17.5,
                            color: AppColor.chocolate,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await onArrowBackPressed(_contentcontroller.text,
                          _contentcontroller.text, time);
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
