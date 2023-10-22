import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Constants/app_color.dart';
import 'package:gesture_memorize/Pages/Note_Page/notes_card.dart';
import 'package:gesture_memorize/Infomations/note_card_info.dart';
import 'package:gesture_memorize/Pages/Note_Page/editing_page.dart';
import 'package:gesture_memorize/global.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
  });

  static String routeName = '/NotesPage';

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    reload();
    Navigator.pop(context);
  }

  onAddNewNotePressed() {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "AddNewNote",
        "time": difference,
      });
      actions.add({
        "name": "AddNewNote",
        "time": difference,
      });
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const EditingPage())))
        .then((_) {
      reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playing && actions.isEmpty) {
      playing = false;
      actions = [];
      reload();
    } else if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
        //NOTE - add any gestures here if needed
        if (!playing || actions.isEmpty) {
          playing = false;
          actions = [];
          reload();
        } else if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        } else if (actions[0]["name"] == "ArrowBack") {
          Navigator.pop(context);
        }
        //NOTE - add any gestures here if needed
        else if (actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed();
        } else if (actions[0]["name"] == "AddNewNote") {
          onAddNewNotePressed();
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.notes_rounded, color: Colors.white),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  const BigText(
                      text: 'M Y  N O T E S',
                      fontColor: Colors.white,
                      size: 20.0),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
              Expanded(
                child: FutureBuilder(
                    future: NoteCardInfo.readData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final notes = snapshot.data!;
                      return GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // childAspectRatio: 1.0,
                          // crossAxisSpacing: 10.0,
                          mainAxisSpacing: 2.0,
                        ),
                        children: notes.map((note) {
                          return NotesCard(
                            title: note['title'],
                            description: note['docs'],
                            date: note['date'],
                            reload: reload,
                          );
                        }).toList(),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onAddNewNotePressed();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: ((context) => EditingPage())));
        },
        backgroundColor: AppColor.almond,
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: BottomNavigation(reload: reload, root: "NotesPage"),
    );
  }
}
