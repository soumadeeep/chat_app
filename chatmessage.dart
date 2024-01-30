import 'package:chat_app/messagebuble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// this class created for swoing my sendin message that i am stored in firestore.
class Pastchat extends StatelessWidget {
  const Pastchat({super.key});
  @override
  Widget build(BuildContext context) {
    final authenticateduser = FirebaseAuth.instance.currentUser!;
    //use stream builder
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            // there we use ordered by because we want to sow our message in created date and time.
            .orderBy(
              'createdat',
              descending: true,
            )
            .snapshots(),
        //end stream
        // start builder
        builder: (ctx, chatsnapshot) {
          if (chatsnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // its and moving animation for waiting period.
            );
          }
          if (!chatsnapshot.hasData || chatsnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No chat"),
            );
          }
          if (chatsnapshot.hasError) {
            return const Center(
              child: Text("somthing wrong"),
            );
          }

          //loadmessages is a list
          final loadmessages = chatsnapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,

            // itemcount use for count total message that improve our listview.
            itemCount: loadmessages.length,
            itemBuilder: (context, index) {
              final chatmessage = loadmessages[index].data();
              final nextchatmessage = index + 1 < loadmessages.length
                  ? loadmessages[index + 1].data()
                  : null;
              final currentmessageuserId = chatmessage['userid'];
              final nextmessageuserId =
                  nextchatmessage != null ? nextchatmessage['userid'] : null;
              final nestuserIssame = currentmessageuserId == nextmessageuserId;
              if (nestuserIssame) {
                return MessageBubble.next(
                  message: chatmessage['text'],
                  isMe: authenticateduser.uid == currentmessageuserId,
                );
              } else {
                return MessageBubble.first(
                    userImage: chatmessage['userimage'],
                    username: chatmessage['username'],
                    message: chatmessage['text'],
                    isMe: authenticateduser.uid == currentmessageuserId);
              }
            },
          );
        });
  }
}
