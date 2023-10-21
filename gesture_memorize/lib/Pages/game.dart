import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/bottom_navigation.dart';
import 'package:intl/intl.dart';
import 'package:gesture_memorize/global.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  static const String routeName = 'game';

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _count = 0;
  int _diff = rewardInval;
  bool _isSparkle = false;
  String _localClaimRewardTime =
      DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
  bool isClaimed = false;
  Timer? timer;
  Timer? timer1;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_diff != 0) _diff = _diff - 1;
      });
    });
    timer1 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isSparkle = !_isSparkle;
      });
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    timer1!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String lastclaimtime = args['lastClaimTime'];
    // _localClaimRewardTime = lastclaimtime;
    int count = args['count'];
    Function addCount = args['addCount'];
    Function rewardCount = args['rewardCount'];
    Function updateClaimTime = args['updateClaimTime'];
    setState(() {
      if (!isClaimed) {
        _localClaimRewardTime = lastclaimtime;
      }
    });
    setState(() {
      _diff = max(
          0,
          rewardInval -
              DateTime.now()
                  .difference(DateTime.parse(_localClaimRewardTime))
                  .inSeconds);
    });

    Widget sparkling(Widget w) {
      return _diff == 0 && _isSparkle ? const SizedBox(width: 0) : w;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          // Text("Logged in at ${args['logintime']}"),
          // Text("Logged in at $_localClaimRewardTime"),
          const SizedBox(width: 8),
          // Text(_localClaimRewardTime, style: TextStyle(fontSize: 0)),
          sparkling(
              Text('${_diff ~/ 60}:${_diff % 60 >= 10 ? "" : 0}${_diff % 60}')),
          _diff == 0
              ? IconButton(
                  onPressed: () {
                    updateClaimTime();
                    rewardCount();
                    setState(() {
                      _diff = 30;
                      _count += 50;
                      _localClaimRewardTime = DateFormat("yyyy-MM-dd HH:mm:ss")
                          .format(DateTime.now())
                          .toString();
                      isClaimed = true;
                    });
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => ClaimReward());
                  },
                  icon: const Icon(Icons.crisis_alert))
              : IconButton(
                  onPressed: () {}, icon: const Icon(Icons.calendar_month)),
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
      ),
      bottomNavigationBar: BottomNavigation(reload: () => setState(() {})),
    );
  }
}

class ClaimReward extends StatefulWidget {
  const ClaimReward({super.key});
  @override
  State<ClaimReward> createState() => _ClaimRewardState();
}

class _ClaimRewardState extends State<ClaimReward> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Congrats!'),
      content: const Text('You have earned 50 counts.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
