import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/alert.dart';
import 'package:gesture_memorize/global.dart';

class BottomNavigation extends StatefulWidget {
  final dynamic reload;
  final String root;
  const BottomNavigation({
    super.key,
    required this.reload,
    required this.root,
  });
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  TextEditingController textFieldController = TextEditingController();
  List<Map<String, dynamic>> filteredGestures = [];
  processGestures() {
    filteredGestures = [];
    print(currentGestures.gestures);
    for (int i = 0; i < currentGestures.gestures.length; i++) {
      if (currentGestures.gestures[i]["root"] == widget.root) {
        print(currentGestures.gestures[i]);
        filteredGestures.add(currentGestures.gestures[i]);
      }
    }
    print("processGestures");
    print(filteredGestures);
    return;
  }

  onRecordPressed() {
    currentGestures.gestures.add({
      "lastActionTime": DateTime.now().millisecondsSinceEpoch,
      "root": widget.root,
      "gesturesName": "",
      "actions": [],
    });
    recording = true;
    widget.reload();
  }

  onStopRecordingPressed() {
    recording = false;
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  textFieldController.text = value;
                });
              },
              controller: textFieldController,
              decoration:
                  const InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  currentGestures.gestures.last["gesturesName"] =
                      textFieldController.text;
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        }));
    widget.reload();
  }

  onPlayPressed() {
    if (currentGestures.gestures.isEmpty) {
      showAlert(
        context: context,
        title: 'Can' 't play actions',
        desc: 'Record actions first',
        onPressed: () {
          Navigator.pop(context);
        },
      ).show();
      return;
    } else {
      processGestures();
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const Text('Action Lists'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Expanded(
                  child: Column(
                    children: [
                      for (int index = 0;
                          index < filteredGestures.length;
                          index++)
                        TextButton(
                          child: Text(filteredGestures[index]["gesturesName"]),
                          onPressed: () {
                            actions = List.from(filteredGestures[index]['actions']);
                            playing = true;
                            Navigator.pop(context);
                            widget.reload();
                          },
                        )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          }));
    }
  }

  onStopPressed() {
    playing = false;
    // setState(() {});
    widget.reload();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          recording
              ? IconButton(
                  onPressed: onStopRecordingPressed,
                  icon: const Icon(
                    Icons.stop_circle,
                    size: 50,
                  ),
                )
              : IconButton(
                  onPressed: onRecordPressed,
                  icon: const Icon(
                    Icons.video_call_rounded,
                    size: 50,
                  ),
                ),
          const SizedBox(width: 50),
          IconButton(
            onPressed: () {
              onReturnHomePressed(context);
            },
            icon: const Icon(
              Icons.home,
              size: 50,
            ),
          ),
          const SizedBox(width: 50),
          playing && actions.isNotEmpty
              ? IconButton(
                  onPressed: onStopPressed,
                  icon: const Icon(
                    Icons.pause_circle,
                    size: 50,
                  ),
                )
              : IconButton(
                  onPressed: onPlayPressed,
                  icon: const Icon(
                    Icons.play_circle,
                    size: 50,
                  ),
                )
        ],
      ),
    );
  }
}
