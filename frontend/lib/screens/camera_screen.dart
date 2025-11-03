import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카메라 화면')),
      body: const Center(
        child: Text('카메라 스크린입니다.'),
      ),
    );
  }
}