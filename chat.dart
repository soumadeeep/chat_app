import 'package:chat_app/chatmessage.dart';
import 'package:chat_app/newchatmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatelessWidget {
  const Chatscreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFB1B0B0),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          title: const Text(
            'Hi...',
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          //here we create log out button.
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
        body: const Column(
          children: [
            Expanded(
              child: Pastchat(),
            ),
            Newchat(),
          ],
        ));
  }
}
