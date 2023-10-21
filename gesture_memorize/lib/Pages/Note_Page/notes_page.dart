import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
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
    num difference = calculateTimeDifference();
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
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const EditingPage())))
        .then((_) {
          print("reload");
      reload();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        else if (actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed();
        } else if (actions[0]["name"] == "AddNewNote") {
          onAddNewNotePressed();
        }
      });
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 130, 180),
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
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio: 1.0,
                    // crossAxisSpacing: 10.0,
                    mainAxisSpacing: 2.0,
                  ),
                  children: NoteCardInfo.notes
                      .map((note) => NotesCard(
                            title: note['title'],
                            description: note['docs'],
                            reload: reload
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onAddNewNotePressed();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: ((context) => EditingPage())));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(reload: reload, root: "NotesPage"),
    );
  }
}
