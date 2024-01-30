import 'package:chat_app/imagepicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;

class Atscreen extends StatefulWidget {
  const Atscreen({super.key});

  @override
  State<Atscreen> createState() => _AtscreenState();
}

class _AtscreenState extends State<Atscreen> {
  var _islogin = true;
  var _emai = '';
  var _password = '';
  var _username = '';
  // ignore: unused_field
  File? _selectedimage;
  var loading = false;

  final _form = GlobalKey<FormState>();
// start button elivated button press proparty
  void _submit() async {
    final isvalid = _form.currentState!.validate();
    //below we use codition important condition
    if (!isvalid) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('please entar valid email id or password'),
      ));
      return;
    }
    if (!_islogin && _selectedimage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('please enter a image'),
      ));
      return;
    }

    _form.currentState!.save();
    // start loading button proparty
    try {
      setState(() {
        loading = true;
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authincation error'),
        ),
      );
    }
// end loadin button proparty
// start login and store proparty
    if (_islogin) {
      try {
        // ignore: unused_local_variable
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _emai, password: _password);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {
          //...
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authincation error'),
          ),
        );
        setState(() {
          loading = false;
        });
      }
    }
    //end login and store property
    // start signup proparty
    else {
      try {
        // ignore: unused_local_variable
        final usercredential = await _firebase.createUserWithEmailAndPassword(
            email: _emai, password: _password);
// uploading the image portion
        final storageref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${usercredential.user!.uid}.jpg');
        await storageref.putFile(_selectedimage!);
        final imageurl = await storageref.getDownloadURL();

        //end the storing image portion
        // start the extra deta storing process usin firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercredential.user!.uid)
            .set({'username': _username, 'email': _emai, 'imageurl': imageurl});
        //and end firestore process
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {
          //...
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authincation error'),
          ),
        );
        setState(() {
          loading = false;
        });
      }
    }
    //end sign up and store proparty
  }
  //end elivated button press proparty

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 60, 67, 72),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                color: const Color.fromARGB(255, 173, 179, 184),
                shadowColor: const Color.fromRGBO(4, 28, 72, 1),
                elevation: 15,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // call user image picker method when is login is false
                            if (!_islogin)
                              Userimagepicker(
                                onpicimage: (pickedimage) {
                                  _selectedimage = pickedimage;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'please enter correct value';
                                }
                                return null;
                              },
                              // create on save method to save  data
                              onSaved: (value) {
                                _emai = value!;
                              },
                            ),
                            if (!_islogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                autocorrect: false,
                                //collect the textformfiled value we use validator
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 4) {
                                    return 'please enter correct user name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _username = value!;
                                },
                              ),

                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'please enter minimum six carecter';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value!;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // here we add loading button
                            if (loading) const CircularProgressIndicator(),
                            // below when loading is false
                            if (!loading)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(_islogin ? 'login' : 'sign up'),
                              ),
                            if (!loading)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _islogin = _islogin ? false : true;
                                    });
                                  },
                                  child: Text(_islogin
                                      ? 'create account'
                                      : 'you have alrady an account'))
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
