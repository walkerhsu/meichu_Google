import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/notes_card.dart';
import 'package:gesture_memorize/Infomations/note_card_info.dart';
import 'package:gesture_memorize/Pages/Note_Page/editing_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
  });

  static const String id = '/notes';

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
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
                      Navigator.pop(context);
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
                      .map((note) => 
                      NotesCard(
                            title: note['title'],
                            description: note['docs'],
                          )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => EditingPage())));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
