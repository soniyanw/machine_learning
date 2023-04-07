import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelling extends StatefulWidget {
  @override
  _ImageLabellingState createState() => _ImageLabellingState();
}

class _ImageLabellingState extends State<ImageLabelling> {
  File? _image;
  List<ImageLabel> _labels = [];

  final ImageLabeler _labeler = GoogleMlKit.vision.imageLabeler();

  Future<void> _getImageAndDetectLabels() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _labels = [];
      });

      final inputImage = InputImage.fromFile(_image!);
      final labels = await _labeler.processImage(inputImage);

      setState(() {
        _labels = labels;
      });
    }
  }

  @override
  void dispose() {
    _labeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Labeling'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 200,
            width: 200,
            child: Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Select Image'),
            onPressed: _getImageAndDetectLabels,
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _labels.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_labels[index].label),
                  subtitle: Text(
                      'Confidence: ${_labels[index].confidence.toStringAsFixed(3)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
