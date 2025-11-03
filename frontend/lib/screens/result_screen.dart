import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('결과 화면')),
      body: const Center(
        child: Text('결과 스크린입니다.'),
      ),
    );
  }
}