import 'package:flutter/material.dart';
// this class buld for wait state between chat and authenticatin screen

class Wait extends StatelessWidget {
  const Wait({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hi')),
      body: const Center(
        child: Text('Hi.....'),
      ),
    );
  }
}
