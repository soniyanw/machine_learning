import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String _result = '';
  File? _selectedImage;

  Future<void> _scanBarcode() async {
    try {
      final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
      final inputImage = InputImage.fromFile(_selectedImage!);
      final barcodes = await barcodeScanner.processImage(inputImage);
      for (Barcode barcode in barcodes) {
        _result += 'Type: ${barcode.type}\nData: ${barcode.rawValue}\n\n';
      }
      barcodeScanner.close();
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null) ...[
                Container(
                  height: 300,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectedImage != null ? _scanBarcode : null,
                child: Text('Scan Barcode'),
              ),
              SizedBox(height: 16),
              Text(
                _result,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
