import 'package:flutter/material.dart';
import 'package:gesture_memorize/Components/Buttons/pushable_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  static const String id = '/homepage';
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/chatbox'),
              icon: const Icon(Icons.message)),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(height: 20),
            PushableButton(
              height: 60,
              elevation: 8,
              hslColor: const HSLColor.fromAHSL(1.0, 229, 1, 0.5),
              shadow: BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
              onPressed: () => Navigator.pushNamed(context, '/create'),
              textChild: const Text('CREATE ROOM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              iconChild: const Icon(
                Icons.create,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            PushableButton(
              height: 60,
              elevation: 8,
              hslColor: const HSLColor.fromAHSL(1.0, 356, 1.0, 0.43),
              shadow: BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
              onPressed: () => Navigator.pushNamed(context, '/join'),
              textChild: const Text('JOIN ROOM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              iconChild: const Icon(
                Icons.add,
                color: Colors.white,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
