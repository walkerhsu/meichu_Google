import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Pages/Note_Page/reading_page.dart';
import 'package:gesture_memorize/global.dart';

class NotesCard extends StatefulWidget {
  const NotesCard({
    super.key,
    this.title = "T I T L E",
    this.description = "brief description",
    this.date = "2021-10-10",
    required this.reload,
  });
  final String title;
  final String description;
  final String date;
  final dynamic reload;

  @override
  State<NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  onCardPressed(title, contents) {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "ToCard",
        "time": difference,
      });
      actions.add({
        "name": "ToCard",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ReadingPage(
                  title: title,
                  contents: contents,
                  date: widget.date,
                  reload: widget.reload,
                )))
        .then((value) {
      widget.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playing && actions.isEmpty) {
      playing = false;
      widget.reload();
    } else if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
        if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        }
        //NOTE - add any gestures here if needed
        else if (actions[0]["name"] == "ToCard") {
          onCardPressed(widget.title, widget.description);
        }
      });
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/notes');
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => onCardPressed(widget.title, widget.description),

            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ReadingPage(
            //         title: widget.title, contents: widget.description))),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 30),
                      child: SmallText(
                          text: widget.title,
                          fontColor: Colors.black,
                          size: 17.5),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  SmallText(text: widget.description)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
