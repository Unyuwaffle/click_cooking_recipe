// lib/screens/home_screen.dart

import 'package:flutter/material.dart' hide Step;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/recipe_provider.dart';
import '../data/models/recipe_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryGreen = Color(0xFF1E6027); // 이미지의 정갈한 초록색
    const bgColor = Color(0xFFF8F9FA);

    final todayRecipe = Recipe(
      recipeId: 999,
      title: "매콤달콤 떡볶이",
      thumbnailUrl: "https://loremflickr.com/600/400/tteokbokki,food",
      matchRate: 100.0,
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
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 🎨 요청하신 이미지 스타일의 정갈한 타이틀
        title: const Text(
          'Click Cooking Recipe',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.w700, // 정갈한 Bold
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.soup_kitchen, size: 60, color: primaryGreen),
                  ),
                  const SizedBox(height: 24),
                  const Text('오늘 냉장고 속 재료로\n어떤 요리를 해볼까요?', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/camera'),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('재료 촬영 시작하기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('오늘의 추천 메뉴', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => context.push('/detail', extra: todayRecipe),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)]),
                      child: Column(
                        children: [
                          ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: Image.network(todayRecipe.thumbnailUrl, height: 180, width: double.infinity, fit: BoxFit.cover)),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(todayRecipe.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const CircleAvatar(backgroundColor: primaryGreen, child: Icon(Icons.chevron_right, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryGreen),
    );
  }

  Widget _buildBottomNav(Color primaryColor) {
    return Container(
      height: 100,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(height: 80, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)])),
          Positioned(bottom: 20, child: Container(width: 75, height: 75, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))]), child: const Icon(Icons.home_filled, color: Colors.white, size: 35))),
        ],
      ),
    );
  }
}