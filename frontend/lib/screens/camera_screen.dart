// (lib/screens/camera_screen.dart)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // Import package
import 'dart:io'; // Import 'File'

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // Store the selected image file
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to pick image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('재료 사진 등록')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show the selected image
            if (_selectedImage != null)
              Container(
                width: 300,
                height: 300,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 300,
                height: 300,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(child: Text('사진을 선택해 주세요')),
              ),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: const Text('갤러리'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _pickImageFromCamera,
                  child: const Text('카메라'),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Submit Button (Using the common widget from Week 1)
            // (You might need to import your PrimaryButton)
            // PrimaryButton(
            //   text: '이 사진으로 레시피 찾기',
            //   onPressed: () {
            //     if (_selectedImage != null) {
            //       // Go to Result screen (We will pass the image in Week 3)
            //       context.go('/result');
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}