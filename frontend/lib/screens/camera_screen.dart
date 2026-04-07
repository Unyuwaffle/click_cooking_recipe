// lib/screens/camera_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/recipe_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  File? _selectedImage; // 선택된 이미지 파일 저장
  final ImagePicker _picker = ImagePicker();

  // 갤러리에서 이미지 가져오기
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // 카메라로 직접 촬영하기
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
    const primaryGreen = Color(0xFF1E6027); // 브랜드 초록색
    const bgColor = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 정갈한 브랜드 타이틀
        title: const Text(
          'Click Cooking Recipe',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                '냉장고 속 재료를\n등록해주세요 🌿',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(height: 32),

              // 🎨 이미지 프리뷰 컨테이너 (고급스러운 카드 스타일)
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('사진을 등록해 주세요', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 🎨 선택 버튼 세트 (갤러리/카메라)
              Row(
                children: [
                  Expanded(
                    child: _buildSelectButton(
                      icon: Icons.photo_library_outlined,
                      label: '갤러리',
                      onPressed: _pickImageFromGallery,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSelectButton(
                      icon: Icons.camera_alt_outlined,
                      label: '카메라',
                      onPressed: _pickImageFromCamera,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 🎨 분석하기 버튼
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedImage != null) {
                      // 이미지 분석 시작
                      await ref.read(recipeProvider.notifier).recognizeIngredientsOnly(_selectedImage!);

                      if (context.mounted) {
                        context.go('/edit-ingredients'); // 수정 화면으로 이동
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('분석할 사진을 먼저 선택해주세요!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('식재료 분석하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 커스텀 선택 버튼 위젯
  Widget _buildSelectButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        foregroundColor: Colors.black87,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}