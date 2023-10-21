import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  static const String routeName = 'game';

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    DateTime now = DateTime.now();
    Duration diff = now.difference(DateTime.parse(args['time']));
    int count = args['count'];
    Function addCount = args['addCount'];

    return Scaffold(
        appBar: AppBar(
          title: Text("Game Page"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[
            Text("Logged in at ${args['time']}"),
            const SizedBox(width: 8),
            diff.inMinutes == 0
                ? IconButton(
                    onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => ClaimReward()),
                    icon: Icon(Icons.crisis_alert))
                : IconButton(
                    onPressed: () {}, icon: Icon(Icons.calendar_month)),
            const SizedBox(width: 8)
          ],
        ),
        body: Align(
            child: Text("You have pushed the button ${_count + count} times.")),
        floatingActionButton: IconButton.filledTonal(
          onPressed: () {
            setState(() {
              _count += 1;
            });
            addCount();
          },
          icon: const Icon(Icons.add),
        ));
  }
}

class ClaimReward extends StatefulWidget {
  ClaimReward({super.key});
  @override
  State<ClaimReward> createState() => _ClaimRewardState();
}

class _ClaimRewardState extends State<ClaimReward> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AlertDialog Title'),
      content: const Text('AlertDialog description'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
