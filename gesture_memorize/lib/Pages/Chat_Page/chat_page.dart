import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Components/chatbox_messages.dart';
import 'package:gesture_memorize/Infomations/chat_info.dart';


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
  int _index = 0;
  // String groupid = "ee4412";
  final TextEditingController _messagecontroller = TextEditingController();
  late String _typeMessage;
  List _allchat = [];

  void _onItemTapped(int idx) {
    setState(() {
      _index = idx;
    });
  }

  Future<void> readJson() async {
    final String response = await rootBundle.rootBundle.loadString('assets/chat.json');
    final data = await json.decode(response);
    setState(() {
      _allchat = data['allchat'];
      print("in");
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    String image = widget.image;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final List selectedChats = [];
    final List chatgptChats = [];
    print(_allchat);
    ChatInfo.allchat.forEach((chat) {
      if (chat["sender"] == name) selectedChats.add(chat);
      if (chat["sender"] == "chatgpt" && chat["receiver"] == name)
        chatgptChats.add(chat);
    });
    print(selectedChats);
    print(chatgptChats);

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
                        Navigator.pop(context);
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
                            text: '#' + widget.groupid, fontColor: Colors.white)
                      ],
                    ),
                    Spacer(),
                    const Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                      size: 40,
                    )
                  ],
                ),
                SizedBox(height: screenHeight / 24),
                const Center(
                  child: SmallText(
                    text: '1 FEB 12:00',
                    fontColor: Colors.white,
                    // style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(height: screenHeight / 89.5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: selectedChats
                      .map((chat) => Padding(
                            padding: EdgeInsets.only(
                                right: screenWidth / 20,
                                bottom: screenHeight / 71.4),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xff373E4E)),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: SmallText(
                                    text: chat["content"],
                                    fontColor: Colors.white,
                                    maxlines: 100,
                                  ),
                                )),
                          ))
                      .toList(),
                ),
                // SizedBox(
                //   height: screenHeight / 71.4,
                // ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff373E4E)),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SmallText(
                        text: (chatgptChats.isNotEmpty)?chatgptChats[0]["content"]: "Hi",
                        fontColor: Colors.white,
                        maxlines: 100,
                      ),
                    )),

                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: screenWidth / 45),
                  // height: screenHeight/10,
                  // margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Container(
                    height: screenHeight / 17,
                    width: screenWidth * 0.95,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff3D4354)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      SizedBox(width: screenWidth / 10),
                      Expanded(
                        flex: 8,
                        // width: screenWidth * 0.65,
                        // height: screenHeight / 12,
                        child: TextFormField(
                          controller: _messagecontroller,
                          onChanged: (value) {
                            _typeMessage = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration.collapsed(
                              filled: true,
                              fillColor: Color(0xff3D4354),
                              hintText: 'Message...',
                              hintStyle: TextStyle(color: Colors.white)),
                          // focusNode: _focusNode,
                        ),
                      ),
                      SizedBox(width: screenWidth / 55),
                      // IconButton(onPressed: () {}, icon: const Icon(Icons.camera)),
                      // IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                      // Spacer(),
                      Expanded(
                        flex:2,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: screenHeight/7),
                          child: SizedBox(
                              height: 10,
                              width: 10,
                              child: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  ChatInfo.allchat.add({
                                    "sender": name,
                                    "content": _typeMessage,
                                  });
                                  setState(() {});
                                  _messagecontroller.clear();
                                },
                                color: Colors.white54,
                              ),
                            ),
                        ),
                        ),
                      
                      SizedBox(width: screenWidth / 45),
                    ]),
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: BottomNavigationBar(
            //   items: const <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.home_filled),
            //       label: 'Home',
            //      ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.group_rounded),
            //       label: 'Groups',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.leaderboard_rounded),
            //       label: 'Notes',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.settings_rounded),
            //       label: 'Settings',
            //     ),
            //   ],
            //   currentIndex: _index,
            //   selectedItemColor: Colors.amber[800],
            //   unselectedItemColor: Colors.grey[800],
            //   backgroundColor: Colors.grey[800],
            //   onTap: _onItemTapped,
            // ),
          ),
        ),
      ),
    );
  }
}
