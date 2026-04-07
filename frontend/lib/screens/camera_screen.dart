// (lib/screens/camera_screen.dart)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // Import package
import 'dart:io'; // Import 'File'
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Use the Common Widget (from FE2 Week 1)
import '../widgets/primary_button.dart';
// Import the provider (from FE1 Week 3)
import '../providers/recipe_provider.dart';

class CameraScreen extends ConsumerStatefulWidget { // (1) Change
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
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
      appBar: AppBar(title: const Text('재료 사진 등록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => context.go('/home'), // 홈으로 초기화 이동
          ),
        ],
      ),
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

            PrimaryButton(
              text: '사진 분석하기',
              onPressed: () async {
                if (_selectedImage != null) {

                  await ref.read(recipeProvider.notifier).recognizeIngredientsOnly(_selectedImage!);

                  if (context.mounted) {
                    context.go('/edit-ingredients');
                  }
                  // --- End of integration logic ---
                } else {
                  // Show an error if no image is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('먼저 사진을 선택해주세요!')),
                  );
                }
              },
            ),


          ],
        ),
      ),
    );
  }
}