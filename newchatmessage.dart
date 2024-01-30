import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Newchat extends StatefulWidget {
  const Newchat({super.key});

  @override
  State<Newchat> createState() => _NewchatState();
}

class _NewchatState extends State<Newchat> {
  final _messagecontroler = TextEditingController();
  @override
  //we use disposer because what i am addin in my text field that are no longer requere that contect should be deleted
  //in our memory that helps clear method to clear textfield and boust the app.
  void dispose() {
    _messagecontroler.dispose();
    super.dispose();
  }

  void _submitmessage() async {
    final entermessage = _messagecontroler.text;
    if (entermessage.trim().isEmpty) {
      return;
    }
    //below line for whwn i am send the message after sending our keybord otometically closed
    FocusScope.of(context).unfocus();
    _messagecontroler.clear();
    //add chat data in firestore
    final user = FirebaseAuth.instance.currentUser!;
    //fetch data from fire store
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': entermessage,
      'createdat': Timestamp.now(),
      'userid': user.uid,
      'username': userdata.data()!['username'],
      'userimage': userdata.data()!['imageurl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            // i create a textfield not text form and i am using expanded metho for proper use of  phone screen.
            child: TextField(
              controller: _messagecontroler,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                  labelText: "Write and Send your Message...."),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _submitmessage,
          )
        ],
      ),
    );
  }
}
