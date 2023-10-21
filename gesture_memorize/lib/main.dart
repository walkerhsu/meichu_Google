import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
import 'package:gesture_memorize/firebase_options.dart';
import 'package:gesture_memorize/global.dart';
import 'package:gesture_memorize/routes/function1_page.dart';
import 'package:gesture_memorize/routes/function2_page.dart';
import 'package:gesture_memorize/Gestures/gestures.dart';
import 'package:gesture_memorize/routes/home_page.dart';
import 'package:gesture_memorize/Pages/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  gestures = Gestures(name: "test");
  // await CloudStorage.uploadGestureData("test");
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
import 'package:gesture_memorize/Pages/Message_Page/chat_page.dart';
import 'package:gesture_memorize/Pages/Note_Page/notes_page.dart';
import 'package:gesture_memorize/Pages/create_room_page.dart';
import 'package:gesture_memorize/Pages/join_room_page.dart';
import 'package:gesture_memorize/Pages/Message_Page/messages_page.dart';
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

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
      ),
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        Function1Page.routeName: (context) => const Function1Page(),
        Function2Page.routeName: (context) => const Function2Page(),
        GamePage.routeName: (context) => GamePage(),
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
      initialRoute: MessagesPage.id,
      routes: {
        MyHomePage.routeName: (context) =>
            const MyHomePage(title: 'Gesture_detector'),
        CreateRoomPage.id: (context) => const CreateRoomPage(),
        JoinRoomPage.id: (context) => const JoinRoomPage(),
        NotesPage.id:(context) => const NotesPage(),
        MessagesPage.id:(context) => const MessagesPage(),
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
      },
    );
  }
}
