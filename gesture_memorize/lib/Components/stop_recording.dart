import 'package:flutter/material.dart';

class StopRecordingButton extends StatelessWidget {
  const StopRecordingButton({super.key});

  onStopRecordingPressed(context) {
    Navigator.pushNamed(context, '/buttonsPage');
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onStopRecordingPressed(context),
      icon: const Icon(
        Icons.home,
      ),
    );
  }
}
