import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Constants/app_color.dart';
import 'package:gesture_memorize/global.dart';

class ReadingPage extends StatefulWidget {
  ReadingPage({this.title = "Untitled", required this.contents, super.key});
  final String title;
  final String contents;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();


  reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _titlecontroller.text = widget.title;
    _contentcontroller.text = widget.contents;
  }

  onArrowBackPressed() {
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
      print("reading page before remove");
      print(actions);
      actions.removeAt(0);
      print("reading page after remove");
      print(actions);
      // print(actions);
    }
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);
    if(playing && actions.isEmpty) {
      playing = false;
      reload();
    }
    else if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
        if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        }
        //NOTE - add any gestures here if needed
        if(actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed();
        }
      });
    }
    
    return Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        onArrowBackPressed();
                        // Navigator.pop(context);
                      },
                    ),
                    // const Icon(Icons.notes_rounded, color: Colors.white),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 30,
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 30),
                        child: TextField(
                          controller: _titlecontroller,
                          decoration:
                              const InputDecoration.collapsed(hintText: "a"),
                        ),
        
                        // BigText(
                        //     text: widget.title,
                        //     fontColor: Colors.white,
                        //     size: 20.0),
                      ),
                    ),
                  ],
                ),
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
                // SmallText(
                //   text: widget.contents,
                //   fontColor: Colors.white,
                // )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(reload: reload, root: "readingPage"));
  }
}
