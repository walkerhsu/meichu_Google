import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Pages/Note_Page/reading_page.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({
    super.key,
    this.title = "T I T L E",
    this.description = "brief description",
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/notes');
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ReadingPage(title: title, contents: description))),
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
                          text: title, fontColor: Colors.black, size: 17.5),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  SmallText(text: description)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
