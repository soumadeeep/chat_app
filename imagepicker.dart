import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Userimagepicker extends StatefulWidget {
  const Userimagepicker({super.key, required this.onpicimage});
  final void Function(File pickedimage) onpicimage;

  @override
  State<Userimagepicker> createState() => _UserimagepickerState();
}

class _UserimagepickerState extends State<Userimagepicker> {
  //here we create file tipe class
  File? _pickedimagefile;
// when we press add image button
  void _pickimage() async {
    final pickedimage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedimage == null) {
      return;
    }
    setState(() {
      _pickedimagefile = File(pickedimage.path);
    });
    widget.onpicimage(_pickedimagefile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color.fromARGB(255, 133, 132, 132),
          foregroundImage:
              _pickedimagefile != null ? FileImage(_pickedimagefile!) : null,
        ),
        //create button with icon
        TextButton.icon(
            onPressed: _pickimage,
            icon: const Icon(Icons.image),
            label: Text(
              'Add image',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ))
      ],
    );
  }
}
