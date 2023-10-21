import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Components/Text/small_text.dart';
import 'package:gesture_memorize/Components/bottom_navigation.dart';
import 'package:gesture_memorize/Constants/app_color.dart';

class ReadingPage extends StatefulWidget {
  ReadingPage({this.title = "Untitled", required this.contents, super.key});
  final String title;
  final String contents;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Step 2 <- SEE HERE
    _titlecontroller.text = widget.title;
    _contentcontroller.text = widget.contents;
  }

  Widget build(BuildContext context) {
    reload() {
      setState(() {});
    }
    // print(MediaQuery.of(context).size.width);
    return Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                  // const Icon(Icons.notes_rounded, color: Colors.white),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 30),
                      child: TextField(
                        controller: _titlecontroller,
                        decoration:
                            const InputDecoration.collapsed(hintText: "a"),
                      ),

                      // BigText(
                      //     text: widget.title,
                      //     fontColor: Colors.white,
                      //     size: 20.0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              TextField(
                controller: _contentcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Note Description',
                ),
              ),
              // SmallText(
              //   text: widget.contents,
              //   fontColor: Colors.white,
              // )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(reload: reload, root: "readingPage"));
  }
}
