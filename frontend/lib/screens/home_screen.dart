import 'package:flutter/material.dart' hide Step;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/primary_button.dart';
import '../providers/recipe_provider.dart';
import '../data/models/recipe_model.dart'; // (1) 모델 임포트 (Mock 데이터용)

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // --- [기존 기능 유지] 에러 리스너 ---
    ref.listen(recipeProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
    // -------------------------------

    // (2) [임시] 오늘의 추천 레시피 가짜 데이터 (나중에 API로 교체)
    final todayRecipe = Recipe(
      recipeId: 999,
      title: "매콤달콤 떡볶이",
      thumbnailUrl: "https://i.namu.wiki/i/GTPc7XqX4M9oaQfDuv4aE3h8wV7L_yV4fOqJ2hXZ6kYx9lW8mN0pQrs1tUv3wXz5.jpg", // 예시 이미지
      matchRate: 100.0, // 오늘의 추천이니 100%
      difficulty: "초급",
      estimatedTime: "20분",
      ingredients: [
        Ingredient(name: "떡", amount: "200g", owned: true),
        Ingredient(name: "어묵", amount: "2장", owned: true),
        Ingredient(name: "고추장", amount: "1큰술", owned: true),
      ],
      steps: [
        RecipeStep(stepNumber: 1, description: "물에 고추장과 설탕을 풉니다."),
        RecipeStep(stepNumber: 2, description: "떡과 어묵을 넣고 끓입니다."),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('찰칵! 쿠킹 레시피'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50], // 배경을 살짝 회색으로 (카드 돋보이게)

      // (3) 스크롤 가능하도록 변경 (화면이 작아도 안 잘리게)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // --- 섹션 1: 메인 기능 (둥근 박스) ---
              Card(
                elevation: 4, // 그림자 효과
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // 둥근 모서리
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    children: [
                      // 아이콘
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined, // 카메라 아이콘으로 변경해봄
                          size: 60,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 텍스트
                      Text(
                        '냉장고 파먹기,\n시작해볼까요?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '재료 사진을 찍으면\nAI가 레시피를 찾아줍니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 버튼
                      PrimaryButton(
                        text: '재료 촬영하기',
                        onPressed: () => context.go('/camera'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // --- 섹션 2: 오늘의 추천 레시피 ---
              const Text(
                '오늘의 추천 메뉴 👨‍🍳',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 추천 레시피 카드
              InkWell(
                // (4) 클릭 시 상세 페이지로 이동 (Mock 데이터 전달)
                onTap: () {
                  context.push('/detail', extra: todayRecipe);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 이미지 영역
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          todayRecipe.thumbnailUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 150, color: Colors.grey[300]),
                        ),
                      ),
                      // 정보 영역
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todayRecipe.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '난이도: ${todayRecipe.difficulty} | ${todayRecipe.estimatedTime}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              backgroundColor: Colors.orangeAccent,
                              child: Icon(Icons.arrow_forward, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 하단 여백
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}