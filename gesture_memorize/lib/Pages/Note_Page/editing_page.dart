import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:gesture_memorize/Constants/app_color.dart';

class EditingPage extends StatefulWidget {
  const EditingPage({super.key});

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  String date = DateTime.now().toString();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
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
                      Navigator.pop(context);
                    },
                  ),
                  const Icon(Icons.new_releases_rounded, color: Colors.white),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  const BigText(
                      text: 'N E W  N O T E S',
                      fontColor: Colors.white,
                      size: 20.0),
                ],
              ),
              TextField(
                controller: _titlecontroller,
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Text(date),
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
            ],
          ),
        ),
      ),
    ); 
  }
}
