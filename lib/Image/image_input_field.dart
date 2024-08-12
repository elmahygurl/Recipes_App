import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputField extends StatefulWidget {
  final ValueChanged<String> onImageChanged;

  ImageInputField({required this.onImageChanged});

  @override
  _ImageInputFieldState createState() => _ImageInputFieldState();
}

class _ImageInputFieldState extends State<ImageInputField> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final base64Image = await _convertFileToBase64(pickedFile);
      setState(() {
        _imageFile = File(pickedFile.path);
        widget.onImageChanged(base64Image);
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final base64Image = await _convertFileToBase64(pickedFile);
      setState(() {
        _imageFile = File(pickedFile.path);
        widget.onImageChanged(base64Image);
      });
    }
  }

  Future<String> _convertFileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  @override 
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final buttonWidth = screenWidth * 0.009;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight*0.002),
        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Upload from Gallery'),
              onPressed: _pickImageFromGallery,
            ),
            SizedBox(width: screenWidth*0.3),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text('Take a Picture'),
              onPressed: _takePicture,
              // style: ElevatedButton.styleFrom(
              //   minimumSize: Size(buttonWidth, buttonWidth*2), 
              // ),
            ),
          ],
        ),
        if (_imageFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.file(
              _imageFile!,
              height: screenHeight * 0.2,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
