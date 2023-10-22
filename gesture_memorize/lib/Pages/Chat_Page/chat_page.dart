import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Infomations/chat_info.dart';
import 'package:gesture_memorize/global.dart';

class ChatboxPage extends StatefulWidget {
  const ChatboxPage({
    super.key,
    required this.name,
    this.image = 'assets/images/stitch.jpg',
    this.groupid = "ee4412",
  });

  static const String id = '/chatbox';
  final String name;
  final String image;
  final String groupid;
  @override
  State<ChatboxPage> createState() => _ChatboxPageState();
}

class _ChatboxPageState extends State<ChatboxPage> {
  final TextEditingController _messagecontroller =
      TextEditingController(text: "");
  String _typeMessage = "";
  Timer? t;

  Future<List<dynamic>> filteredReadData() async {
    List<Map<String, dynamic>> data = await ChatInfo.readData("chat.json");
    final filteredChats = [];
    // final receivedChats = [];

    data.forEach((chat) {
      if (chat["receiver"] == widget.name && chat["sender"] == "me" ||
          (chat["receiver"] == "me")) {
        filteredChats.add(chat);
      }
    });
    // print("filterChat: ");
    // print(filteredChats);
    // print("receivedChats: ");
    // print(receivedChats);
    return filteredChats;
  }

  onSendMessagePressed() async {
    if (recording) {
      num difference = calculateTimeDifference();
      if (difference > 2000) difference = 2000;
      currentGestures.gestures.last["actions"].add({
        "name": "MessageSent",
        "time": difference,
        "message": _typeMessage,
      });
      actions.add({
        "name": "MessageSent",
        "time": difference,
        "message": _typeMessage,
      });
    } else if (playing && actions.isNotEmpty) {
      _typeMessage = actions[0]["message"] ?? "";
      actions.removeAt(0);
    }

    saveData().then((_) {
      _messagecontroller.clear();
      reload();
    });
  }

  Future<int> saveData() async {
    await ChatInfo.addData({
      "sender": "me",
      "receiver": widget.name,
      "content": _typeMessage,
    });
    return 1;
  }

  reload() {
    if (mounted) {
      setState(() {});
    }
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
    }
    Navigator.popUntil(context, ModalRoute.withName('/MessagesPage'));
    t?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _messagecontroller.dispose();
    t?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    String image = widget.image;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    if (playing && actions.isEmpty) {
      playing = false;
      reload();
    } else if (playing && actions.isNotEmpty) {
      // if (actions[0]["name"] == "MessageSent") {
      //   _typeMessage = actions[0]["message"] ?? "";
      //   _messagecontroller.text = _typeMessage;
      // }
    t?.cancel();
        t = Timer(Duration(milliseconds: actions[0]["time"]), () {
        if (!playing || actions.isEmpty) {
          playing = false;
          actions = [];
          reload();
        } else if (actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed();
        } else if (actions[0]["name"] == "MessageSent") {
          onSendMessagePressed();
        }
        //NOTE - add any gestures here if needed
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SafeArea(
            child: Column(
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
                      },
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: Image.asset(image).image,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmallText(
                            text: name,
                            size: 18,
                            fontFamily: ('Quicksand'),
                            fontColor: Colors.white),
                        SizedBox(height: screenHeight / 120),
                        SmallText(
                            text: '#${widget.groupid}', fontColor: Colors.white)
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: screenHeight / 24),
                const Center(
                  child: SmallText(
                    text: '1 FEB 12:00',
                    fontColor: Colors.white70,
                  ),
                ),
                SizedBox(height: screenHeight / 89.5),
                FutureBuilder(
                    future: filteredReadData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: snapshot.data!
                                  .map((chat) => Padding(
                                        padding: EdgeInsets.only(
                                            right: (chat["receiver"] == "me")
                                                ? (screenWidth * 0.5)
                                                : (screenWidth / 50),
                                            bottom: screenHeight / 71.4),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xff373E4E)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: SmallText(
                                                text: chat["content"],
                                                fontColor: Colors.white,
                                                maxlines: 100,
                                              ),
                                            )),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    }),

                // const Spacer(),
                Container(
                  padding: EdgeInsets.only(bottom: screenWidth / 45),
                  // height: screenHeight/10,
                  // margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Container(
                    height: screenHeight / 17,
                    width: screenWidth * 0.95,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xff3D4354)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: screenWidth / 10),
                          Expanded(
                            flex: 8,
                            // width: screenWidth * 0.65,
                            // height: screenHeight / 12,
                            child: TextField(
                              controller: _messagecontroller,
                              onChanged: (value) {
                                _typeMessage = value;
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autofocus: true,
                              style: const TextStyle(color: Colors.white),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: const InputDecoration.collapsed(
                                filled: true,
                                fillColor: Color(0xff3D4354),
                                hintText: 'Message...',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              // focusNode: _focusNode,
                            ),
                          ),
                          SizedBox(width: screenWidth / 55),
                          // IconButton(onPressed: () {}, icon: const Icon(Icons.camera)),
                          // IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                          // Spacer(),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () async {
                                await onSendMessagePressed();
                              },
                              color: Colors.white54,
                            ),
                          ),

                          SizedBox(width: screenWidth / 45),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
