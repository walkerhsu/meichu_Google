import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Components/alert.dart';
import 'package:gesture_memorize/global.dart';

class BottomNavigation extends StatefulWidget {
  final dynamic reload;
  final String root;
  const BottomNavigation({
    super.key,
    required this.reload,
    required this.root,
  });
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  TextEditingController textFieldController = TextEditingController();
  List<Map<String, dynamic>> filteredGestures = [];
  String errorText = "";

  processGestures() {
    filteredGestures = [];
    for (int i = 0; i < currentGestures.gestures.length; i++) {
      if (currentGestures.gestures[i]["root"] == widget.root) {
        filteredGestures.add(currentGestures.gestures[i]);
      }
    }
    return;
  }

  onRecordPressed() {
    currentGestures.gestures.add({
      "lastActionTime": DateTime.now().millisecondsSinceEpoch,
      "root": widget.root,
      "gesturesName": "",
      "actions": [],
    });
    recording = true;
    widget.reload();
  }

  onStopRecordingPressed() {
    recording = false;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const BigText(text: 'Name your actions', size: 22),
            content: TextField(
              onChanged: (value) {
                print(value.isEmpty);
                print(errorText);
                if (value.isEmpty) {
                  setState(() {
                    errorText = "Name can't be empty";
                    
                  });
                } else {
                  setState(() {
                    errorText = "";
                  });
                  setState(() {
                    textFieldController.text = value;
                  });
                }
              },
              controller: textFieldController,
              decoration: InputDecoration(
                hintText: "your action name",
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorText: errorText == "" ? null : errorText,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  currentGestures.gestures.removeLast();
                  Navigator.pop(context);
                },
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset("assets/images/cancel.png")),
              ),
              TextButton(
                onPressed: () {
                  if (textFieldController.text == "") {
                    setState(() {
                      errorText = "Name can't be empty";
                    });
                  } else {
                    setState(() {
                      errorText = "";
                    });
                    currentGestures.gestures.last["gesturesName"] =
                        textFieldController.text;
                    Navigator.pop(context);
                  }
                },
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset("assets/images/ok.png")),
              ),
            ],
          );
        }));
    widget.reload();
  }

  onPlayPressed() {
    if (currentGestures.gestures.isEmpty) {
      showAlert(
        context: context,
        title: "Can't play actions",
        desc: 'Record actions first',
        onPressed: () {
          Navigator.pop(context);
        },
      ).show();
      return;
    } else {
      processGestures();
      if (filteredGestures.isEmpty) {
        showAlert(
          context: context,
          title: "No actions recorded at this page",
          desc: 'Go to other pages to start the actions',
          onPressed: () {
            Navigator.pop(context);
          },
        ).show();
        return;
      }
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const BigText(text: 'Action Lists'),
              content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.maxFinite,
                  child: Scrollbar(
                    child: ListView.separated(
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            actions =
                                List.from(filteredGestures[index]['actions']);
                            playing = true;
                            Navigator.pop(context);
                            widget.reload();
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/action.png',
                              width: 30,
                              height: 30,
                            ),
                            title: SmallText(
                                text: filteredGestures[index]["gesturesName"],
                                size: 20),
                            trailing: InkWell(
                              onTap: () {
                                for (int i = 0;
                                    i < currentGestures.gestures.length;
                                    i++) {
                                  if (currentGestures.gestures[i]
                                          ["gesturesName"] ==
                                      filteredGestures[index]["gesturesName"]) {
                                    currentGestures.gestures.removeAt(i);
                                    break;
                                  }
                                }
                                Navigator.pop(context);
                                widget.reload();
                              },
                              child: Image.asset(
                                  width: 30,
                                  height: 30,
                                  "assets/images/recycling-bin.png"),
                            ),
                          ),
                        );
                      }),
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(height: 1);
                      },
                      itemCount: filteredGestures.length,
                    ),
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const SmallText(
                    text: 'Cancel',
                    size: 15,
                  ),
                ),
              ],
            );
          }));
    }
  }

  onStopPressed() {
    playing = false;
    // setState(() {});
    widget.reload();
  }

  @override
  Widget build(BuildContext context) {
    // return GNav(
    //   rippleColor: Colors.grey[300]!,
    //   hoverColor: Colors.grey[100]!,
    //   gap: 8,
    //   activeColor: Colors.black,
    //   iconSize: 32,
    //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    //   duration: Duration(milliseconds: 400),
    //   tabBackgroundColor: Colors.grey[100]!,
    //   color: Colors.black,
    //   tabs: [
    //     GButton(icon: LineIcons.video, text: 'record'),
    //     GButton(icon: LineIcons.home, text: 'home'),
    //     GButton(icon: LineIcons.playCircle, text: 'play'),
    //   ],
    //   selectedIndex: _selectedIndex,
    //   onTabChange: (index) {
    //     setState(() {
    //       _selectedIndex = index;
    //     });
    //   },
    // );
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Color.fromARGB(255, 255, 255, 255),
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            recording
                ? GestureDetector(
                    onTap: () {
                      onStopRecordingPressed();
                    },
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/stop-sign.png')),
                  )
                : GestureDetector(
                    onTap: () {
                      onRecordPressed();
                    },
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/video-player.png')),
                  ),
            const SizedBox(width: 50),
            GestureDetector(
              onTap: () {
                onReturnHomePressed(context);
              },
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/images/home.png')),
            ),
            // IconButton(
            //   onPressed: () {
            //     onReturnHomePressed(context);
            //   },
            //   icon: const Icon(
            //     Icons.home,
            //     size: 50,
            //     color: Color(0xff2d386b),
            //   ),
            // ),
            const SizedBox(width: 50),
            playing && actions.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      onStopPressed();
                    },
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/images/stop.png')),
                  )
                : GestureDetector(
                    onTap: () {
                      onPlayPressed();
                    },
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset('assets/images/play.png')),
                  ),
          ],
        ),
      ),
    );
  }
}
