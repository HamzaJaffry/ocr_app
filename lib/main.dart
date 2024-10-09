import 'package:flutter/material.dart';
import 'text_recognition_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Text Recognition App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: TextRecognitionScreen(),
  ));
}
