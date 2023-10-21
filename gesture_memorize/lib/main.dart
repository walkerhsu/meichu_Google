import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gesture_memorize/firebase_options.dart';
import 'package:gesture_memorize/global.dart';
import 'package:gesture_memorize/routes/function1_page.dart';
import 'package:gesture_memorize/routes/function2_page.dart';
import 'package:gesture_memorize/Gestures/gestures.dart';
import 'package:gesture_memorize/routes/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  gestures = Gestures(name: "test");
  // await CloudStorage.uploadGestureData("test");
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
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        Function1Page.routeName: (context) => const Function1Page(),
        Function2Page.routeName: (context) => const Function2Page(),
      },
    );
  }
}
