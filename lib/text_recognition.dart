import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognition extends StatefulWidget {
  @override
  _TextRecognitionState createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  String _recognizedText = '';
  File? _selectedImage;

  Future<void> _readTextFromImage() async {
    PickedFile? file =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (file == null) return;

    final InputImage inputImage = InputImage.fromFile(File(file.path));
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText =
        await textDetector.processImage(inputImage);

    setState(() {
      _recognizedText = '';

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            _recognizedText += element.text + ' ';
          }
          _recognizedText += '\n';
        }
        _recognizedText += '\n';
      }

      textDetector.close();
      _selectedImage = File(file.path); // Store the selected image file
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (_selectedImage != null)
            Container(
              height: 200,
              child: Image.file(_selectedImage!),
            ),
          SizedBox(height: 10),
          Text(
            'Recognized Text:',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _recognizedText,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _readTextFromImage,
            child: Text('Select Image'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
