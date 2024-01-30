import 'package:chat_app/chat.dart';
import 'package:chat_app/login.dart';
import 'package:chat_app/wait.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter chatapp',
        theme: ThemeData().copyWith(
          // ignore: deprecated_member_use
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        //below we create a stream bulder method that healps us to reach letest screen
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            //midiater screen
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Wait();
            }
            if (snapshot.hasData) {
              return const Chatscreen();
            }
            // this is default return it ocure when we have no snapshot.
            return const Atscreen();
          },
        ));
  }
}
