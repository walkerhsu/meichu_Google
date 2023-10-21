import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Infomations/message_list_info.dart';
import 'package:gesture_memorize/Pages/Chat_Page/chat_page.dart';
import 'package:gesture_memorize/global.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);
  static const String id = '/messages';
  static String routeName = '/MessagesPage';

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  reload() {
    setState(() {});
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
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.pop(context);
  }

  onMessagePressed(Map<String, dynamic> person) {
    if (recording) {
      print("in recording");
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "Message",
        "time": difference,
        "person": person,
      });
      actions.add({
        "name": "Message",
        "time": difference,
        "person": person,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatboxPage(
                  name: person["name"],
                  image: person["image"],
                ))).then((_) {
      reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final users = {...MessageListInfo.people, ...MessageListInfo.recentpeople};
    // print(MediaQuery.of(context).size.height);
    // print(MediaQuery.of(context).size.width);
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
          onArrowBackPressed();
        } else if (actions[0]["name"] == "Message") {
          onMessagePressed(actions[0]["person"]);
        }
        //NOTE - add any gestures here if needed
      });
    }
    List<Map<String, dynamic>> searchName(String str) {
      List<Map<String, dynamic>> results = [];
      for (var user in users) {
        if (user['name'].toLowerCase().contains(str.toLowerCase())) {
          results.add(user);
        }
      }
      return results;
    }

    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SafeArea(
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
                    onPressed: () {
                      onArrowBackPressed();
                      // Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Messages',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ('Quicksand'),
                        fontSize: 30,
                        color: Colors.white),
                  ),
                  const Spacer(),
                  SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
                    return IconButton(
                        onPressed: () {
                          controller.openView();
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 36,
                        ));
                  }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    List<Map<String, dynamic>> results =
                        searchName(controller.text);
                    // print(results.take(15).toList());
                    return results.take(15).map((user) {
                      return ListTile(
                        title: Row(
                          children: <Widget>[
                            CircleAvatar(
                                backgroundImage: AssetImage(user['image'])),
                            // const SizedBox(width: 30),
                            Text(user['name']),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            controller.closeView(user['name']);
                            controller.text = '';
                          });
                        },
                      );
                    });
                  }),
                ],
              ),
              SizedBox(
                height: screenHeight / 45,
              ),
              const Text(
                'R E C E N T',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: screenHeight / 45,
              ),
              SizedBox(
                height: screenHeight / 6.5,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  for (int i = 0; i < MessageListInfo.recentpeople.length; i++)
                    Row(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: Image.asset(
                                    MessageListInfo.recentpeople[i]["image"])
                                .image,
                          ),
                          SizedBox(
                            height: screenHeight / 71.6,
                          ),
                          Text(
                            MessageListInfo.recentpeople[i]["name"],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                      SizedBox(
                        width: screenWidth / 14.4,
                      ),
                    ]),
                ]),
              ),
              SizedBox(
                height: screenHeight / 35.7,
              ),
              SingleChildScrollView(
                child: Container(
                  height: screenHeight / 1.98,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color(0xff292F3F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight / 65, bottom: screenWidth / 50),
                    child: Expanded(
                      child: ListView(
                        children: [
                          for (int i = 0;
                              i < MessageListInfo.people.length;
                              i++)
                            GestureDetector(
                              onTap: () {
                                onMessagePressed(MessageListInfo.people[i]);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth / 13.85,
                                    top: screenHeight / 35.7,
                                    right: screenWidth / 36),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: Image.asset(
                                              MessageListInfo.people[i]
                                                  ["image"])
                                          .image,
                                    ),
                                    SizedBox(
                                      width: screenWidth / 36,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth / 3,
                                              child: Text(
                                                MessageListInfo.people[i]
                                                    ["name"],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: ('Quicksand'),
                                                    fontSize: 17),
                                              ),
                                            ),
                                            SizedBox(width: screenWidth / 6
                                                // width: 100,
                                                ),
                                            Text(
                                              MessageListInfo.people[i]["date"],
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight / 143.2,
                                        ),
                                        Text(
                                          MessageListInfo.people[i]["gmail"],
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNavigation(reload: reload, root: "MessagesPage"),
    );
  }
}
