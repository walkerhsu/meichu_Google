import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Constants/app_color.dart';
import 'package:gesture_memorize/global.dart';
import 'package:gesture_memorize/Infomations/note_card_info.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage(
      {this.title = "Untitled",
      required this.contents,
      required this.date,
      required this.reload,
      super.key});
  final String title;
  final String contents;
  final String date;
  final Function reload;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();
  Timer? timer;
  reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _titlecontroller.text = widget.title;
    _contentcontroller.text = widget.contents;
  }

  @override
  void dispose() {
    super.dispose();
    _titlecontroller.dispose();
    _contentcontroller.dispose();
    timer?.cancel();
  }

  onArrowBackPressed() {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "ArrowBack",
        "time": difference,
      });
      actions.add({
        "name": "ArrowBack",
        "time": difference,
      });
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
      // print(actions);
    }
    Navigator.pop(context);
  }

  onNoteBookChanged(String text) async {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "NoteBookChanged",
        "time": difference,
        "title": text,
        "content": text,
      });
      actions.add({
        "name": "NoteBookChanged",
        "time": difference,
        "title": text,
        "content": text,
      });
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    await NoteCardInfo.editData(widget.date, text, text);
    reload();
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
          widget.reload();
        } else if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        } else if (actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed();
        } else if (actions[0]["name"] == "NoteBookChanged") {
          print(actions[0]["content"] ?? "");
          onNoteBookChanged(actions[0]["content"] ?? "");
        }
        //NOTE - add any gestures here if needed
      });
    }

    return Scaffold(
        backgroundColor: AppColor.almond,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth,
                child: Row(children: [
                  IconButton(
                    iconSize: 20,
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColor.chocolate,
                    ),
                    onPressed: () {
                      onArrowBackPressed();
                      // Navigator.pop(context);
                    },
                  ),
                  Flexible(
                    child: BigText(
                        maxlines: 1,
                        text: (widget.contents == "")
                            ? "Untitled"
                            : widget.contents,
                        fontColor: AppColor.chocolate,
                        size: 20.0),
                  ),
                  const Spacer(),
                  SizedBox(width: screenWidth / 10),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: AppColor.chocolate,
                    ),
                    onPressed: () async {
                      await NoteCardInfo.deleteData(widget.date)
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                ]),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
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
                          onChanged: (_) async {
                            await onNoteBookChanged(_contentcontroller.text);
                          },
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
                      await NoteCardInfo.editData(widget.date,
                              _contentcontroller.text, _contentcontroller.text)
                          .then((value) => Navigator.pop(context));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: const SmallText(
                      text: 'Save',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
        bottomNavigationBar: BottomNavigation(
          reload: reload,
          root: "readingPage",
          bgcolor: const Color.fromARGB(255, 228, 215, 194),
        ));
  }
}
