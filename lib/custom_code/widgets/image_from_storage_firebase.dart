// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_image/firebase_image.dart';

class ImageFromStorageFirebase extends StatelessWidget {
  const ImageFromStorageFirebase({
    Key? key,
    this.width,
    this.height,
    required this.folder,
    required this.imageName,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String folder;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        image: FirebaseImage('gs://pharmaff-dab40.appspot.com/userIcon123.jpg'),
        // Works with standard parameters, e.g.
        fit: BoxFit.fitWidth,
        width: 100,
        // ... etc.
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the button on the right!
