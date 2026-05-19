// lib/screens/camera_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/recipe_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  File? _selectedImage;
  bool _isAnalyzing = false; // 서버 API 통신 상태 관리용 변수
  final ImagePicker _picker = ImagePicker();

  /// 카메라로 사진 촬영
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }

  /// 갤러리에서 사진 선택
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  /// 서버로 이미지를 전송하고 분석 결과를 받아오는 함수
  Future<void> _analyzeImage() async {
    // 1. 이미지 선택 여부 검증
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 요리 재료 사진을 촬영하거나 선택해주세요.')),
      );
      return;
    }

    // 2. 통신 시작 전 로딩 상태 켜기 (버튼 비활성화 및 로딩 스피너 표시)
    setState(() {
      _isAnalyzing = true;
    });

    try {
      // 3. 서버(FastAPI)로 이미지 전송 및 YOLO 분석 대기
      // 주의: recipeProvider와 recognizeIngredientsOnly는 실제 정의하신 이름에 맞게 사용하세요.
      await ref.read(recipeProvider.notifier).recognizeIngredientsOnly(_selectedImage!);

      // 4. 비동기 작업 후 화면 이동 시 context.mounted 체크는 필수입니다.
      if (context.mounted) {
        context.go('/edit-ingredients'); // 재료 수정 화면으로 안전하게 이동
      }
    } catch (e) {
      // 5. 서버 오류 또는 네트워크 에러 발생 시 사용자에게 알림
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('분석 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      // 6. 성공/실패 여부와 상관없이 통신이 끝나면 로딩 상태 해제
      if (context.mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF1E6027); // 프로젝트 메인 컬러

    return Scaffold(
        appBar: AppBar(
          title: const Text('재료 촬영하기'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            // --- 이미지 미리보기 영역 ---
            Expanded(
            child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: _selectedImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              ),
            )
                : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_search, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '냉장고 속 재료를 촬영해보세요!',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // --- 사진 선택 버튼 영역 ---
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                // 분석 중일 때는 버튼 클릭을 막습니다.
                onPressed: _isAnalyzing ? null : _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('카메라'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: primaryGreen,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isAnalyzing ? null : _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('갤러리'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: primaryGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // --- AI 분석 요청 버튼 ---
        ElevatedButton(
            onPressed: _isAnalyzing ? null : _analyzeImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isAnalyzing
                ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white, // 배경이 짙은 초록색이므로 흰색 스피너 사용
                ),
            )
                : const Text(
              '식재료 분석하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ),
              ],
            ),
          ),
        ),
    );
  }
}