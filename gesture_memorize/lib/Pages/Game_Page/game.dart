import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Navigators/bottom_navigation.dart';
import 'package:gesture_memorize/Components/Text/big_text.dart';
import 'package:intl/intl.dart';
import 'package:gesture_memorize/global.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  static const String routeName = '/GamePage';

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

  reload() {
    setState(() {});
  }

  onArrowBackPressed() {
    if (recording) {
      num difference = calculateTimeDifference();
      currentGestures.gestures.last["actions"].add({
        "name": "ArrowBack",
        "time": difference,
      });
      actions.add({
        "name": "ArrowBack",
        "time": difference,
      });
    } else if (playing) {
      actions.removeAt(0);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
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

    if(playing && actions.isEmpty) {
      playing = false;
      reload();
    }
    else if (playing && actions.isNotEmpty) {
      Future.delayed(Duration(milliseconds: actions[0]["time"]), () {
        if (actions[0]["name"] == "ReturnHome") {
          onReturnHomePressed(context);
        }
        //NOTE - add any gestures here if needed
        if(actions[0]["name"] == "ArrowBack") {
          onArrowBackPressed();
        }
      });
    }

    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          iconSize: 20,
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            onArrowBackPressed();
                          },
                        ),
                        const SizedBox(width: 10),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        const BigText(
                          text: "Game Page",
                          size: 20,
                        ),
                        // Text("Logged in at ${args['time']}")
                        // ],
                        // ),
                        const SizedBox(width: 8),
                        Spacer(),
                        sparkling(Text(
                            '${_diff ~/ 60}:${_diff % 60 >= 10 ? "" : 0}${_diff % 60}')),
                        _diff == 0
                            ? IconButton(
                                onPressed: () {
                                  updateClaimTime();
                                  rewardCount();
                                  setState(() {
                                    _diff = 30;
                                    _count += 50;
                                    _localClaimRewardTime =
                                        DateFormat("yyyy-MM-dd HH:mm:ss")
                                            .format(DateTime.now())
                                            .toString();
                                    isClaimed = true;
                                  });
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ClaimReward());
                                },
                                icon: const Icon(Icons.crisis_alert))
                            : IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.calendar_month)),
                        const SizedBox(width: 8)
                      ],
                    ),
                    SizedBox(height: screenHeight / 3),
                    Align(
                        child: Text(
                            "You have pushed the button ${_count + count} times.")),
                  ]))),
      floatingActionButton: IconButton.filledTonal(
        onPressed: () {
          setState(() {
            _count += 1;
          });
          addCount();
        },
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigation(reload: reload, root: "GamePage"),
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
