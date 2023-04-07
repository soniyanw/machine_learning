import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class FaceRecognition extends StatefulWidget {
  @override
  _FaceRecognitionState createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  File? _imageFile;
  final picker = ImagePicker();

  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();

  List<Face>? _faces;

  bool _isImageLoaded = false;

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _isImageLoaded = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _detectFaces() async {
    final inputImage = InputImage.fromFile(_imageFile!);
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
      enableContours: true,
    );

    final faces = await faceDetector.processImage(inputImage);
    if (mounted) {
      setState(() {
        _faces = faces;
      });
    }
  }

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Center(
              child: _isImageLoaded
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    )
                  : Text('No image selected'),
            ),
          ),
          ElevatedButton(
            onPressed: _getImage,
            child: Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: _detectFaces,
            child: Text('Detect Faces'),
          ),
          (_faces != null && _imageFile != null)
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _faces == null ? 0 : _faces!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final face = _faces![index];
                      return ListTile(
                        leading: Image.file(
                          _imageFile!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          alignment: FractionalOffset(
                            face.boundingBox.left,
                            face.boundingBox.top,
                          ),
                        ),
                        title: Text('Face $index'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                'Smiling probability: ${face.smilingProbability}'),
                            Text(
                                'Left eye open probability: ${face.leftEyeOpenProbability}'),
                            Text(
                                'Right eye open probability: ${face.rightEyeOpenProbability}'),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
