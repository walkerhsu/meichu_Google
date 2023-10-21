import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/alert.dart';
import 'package:gesture_memorize/global.dart';

class BottomNavigation extends StatefulWidget {
  final dynamic reload;
  const BottomNavigation({
    super.key,
    required this.reload,
  });
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  onRecordPressed() {
    gestures.gestures.add([]);
    recording = true;
    widget.reload();
  }

  onStopRecordingPressed() {
    recording = false;
    // setState(() {});
    widget.reload();
  }

  onPlayPressed() {
    if (gestures.gestures.isEmpty) {
      showAlert(
        context: context,
        title: 'Can''t play actions',
        desc: 'Record actions first',
        onPressed: () {
          Navigator.pop(context);
        },
      ).show();
      return;
    }
    actions = gestures.gestures.last;
    playing = true;
    // setState(() {});
    widget.reload();
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
          playing
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
