import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gesture_memorize/Pages/Note_Page/notes_page.dart';
import 'package:gesture_memorize/Pages/Chat_Page/messages_page.dart';
import 'package:gesture_memorize/Pages/home_page.dart';
import 'package:gesture_memorize/firebase_options.dart';
import 'package:gesture_memorize/global.dart';
import 'package:gesture_memorize/Gestures/gestures.dart';
import 'package:gesture_memorize/Pages/Game_Page/game.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  currentGestures = Gestures(userName: "test");
  // await CloudStorage.uploadGestureData("test");
  initTime = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
  lastclaimtime =
      DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();
  int count = 0;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture_detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // bottomAppBarTheme:BottomAppBarTheme(
        //   color: Colors.white,
        // ),
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        GamePage.routeName: (context) => const GamePage(),
        NotesPage.routeName: (context) => const NotesPage(),
        MessagesPage.routeName: (context) => const MessagesPage(),
      },
    );
  }
}
