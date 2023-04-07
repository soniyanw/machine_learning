import 'package:flutter/material.dart';
import 'package:machine_learning_eg/barcode_scanning.dart';
import 'package:machine_learning_eg/face_recognition.dart';
import 'package:machine_learning_eg/image_labelling.dart';
import 'package:machine_learning_eg/text_recognition.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MachineLearningEg()));
}

class MachineLearningEg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Machine Learning"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FaceRecognition()));
                },
                child: Text("Face Recognition")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TextRecognition()));
                },
                child: Text("Text Recognition")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImageLabelling()));
                },
                child: Text("Image Labelling")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BarcodeScanner()));
                },
                child: Text("Barcode Scanner"))
          ],
        ),
      ),
    );
  }
}
