
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInputField extends StatefulWidget {
  final TextEditingController controller;

  ImageInputField({required this.controller});

  @override
  _ImageInputFieldState createState() => _ImageInputFieldState();
}

class _ImageInputFieldState extends State<ImageInputField> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        widget.controller.text = pickedFile.path;
      });
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        widget.controller.text = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(labelText: 'Image URL'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an image URL';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Upload from Gallery'),
              onPressed: _pickImageFromGallery,
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text('Take a Picture'),
              onPressed: _takePicture,
            ),
          ],
        ),
        if (_imageFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.file(
              _imageFile!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
