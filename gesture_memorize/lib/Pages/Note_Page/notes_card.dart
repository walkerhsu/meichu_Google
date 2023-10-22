import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Constants/app_color.dart';
import 'package:gesture_memorize/Pages/Note_Page/reading_page.dart';
import 'package:gesture_memorize/global.dart';

class NotesCard extends StatefulWidget {
  const NotesCard({
    super.key,
    this.title = "T I T L E",
    this.description = "brief description",
    this.date = "2023-10-22",
    this.time = "",
    required this.reload,
  });
  final String title;
  final String description;
  final String date;
  final String time;
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
        "title": widget.title,
        "contents": widget.description,
      });
      actions.add({
        "name": "ToCard",
        "time": difference,
        "title": widget.title,
        "contents": widget.description,
      });
    } else if (playing && actions.isNotEmpty) {
      actions.removeAt(0);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ReadingPage(
                  title: (title == "") ? "Untitled" : title,
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
        if (!playing || actions.isEmpty) {
          playing = false;
          actions = [];
          widget.reload();
        } else if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        } else if (actions[0]["name"] == "ToCard") {
          onCardPressed(actions[0]["title"], actions[0]["contents"]);
        }
        //NOTE - add any gestures here if needed
      });
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/notes');
      },
      child: Card(
        color: AppColor.almond,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => onCardPressed(widget.title, widget.description),

            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ReadingPage(
            //         title: widget.title, contents: widget.description))),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.height / 45,
                        left: MediaQuery.of(context).size.height / 45),
                    // width: MediaQuery.of(context).size.width/4,
                    child: SmallText(
                        text: (widget.title == "") ? "Untitled" : widget.title,
                        fontColor: Colors.black,
                        size: 17.5),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 45,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: SmallText(
                        text: widget.description,
                        maxlines: 3,
                      )),
                    ],
                  ),
                  Spacer(),
                  SmallText(text: widget.time)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
