import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // (1) Riverpod 추가
import 'package:go_router/go_router.dart';

import '../widgets/primary_button.dart';
import '../providers/recipe_provider.dart'; // (2) Provider import (폴더명 providers 확인)

// (3) StatelessWidget -> ConsumerWidget 변경 (ref 사용을 위해)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  // (4) build 메서드에 WidgetRef ref 추가
  Widget build(BuildContext context, WidgetRef ref) {

    // --- [FE2 핵심 작업] 에러 리스너 등록 ---
    // recipeProvider의 상태가 변할 때마다 이 코드가 실행됩니다.
    ref.listen(recipeProvider, (previous, next) {

      // "새로운 상태에 에러가 있고" && "로딩 중이 아닐 때" (로딩 중 에러는 무시 or 별도 처리)
      if (next.hasError && !next.isLoading) {

        // 에러 메시지 가져오기
        final errorMessage = next.error.toString();

        // SnackBar(하단 팝업) 띄우기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating, // 바닥에서 살짝 띄우기
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '닫기',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
    // --- [에러 리스너 끝] ---


    return Scaffold(
      appBar: AppBar(
        title: const Text('찰칵! 쿠킹 레시피'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. 로고 또는 아이콘 (UI 폴리싱)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.soup_kitchen, // 요리 관련 아이콘
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),

              // 2. 안내 멘트 (UI 폴리싱)
              Text(
                '냉장고 속 재료,\n어떻게 요리할지 고민되시나요?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '재료 사진만 찍으면\nAI가 맛있는 레시피를 추천해 드려요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // 3. 메인 액션 버튼 (기존 기능)
              PrimaryButton(
                text: '레시피 찾으러 가기!',
                onPressed: () {
                  // 카메라 화면으로 이동
                  context.go('/camera');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}