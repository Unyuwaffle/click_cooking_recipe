// lib/screens/result_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/recipe_provider.dart';

// 스크롤바 컨트롤러 관리를 위해 ConsumerStatefulWidget으로 변경했습니다.
class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1E6027);
    const bgColor = Color(0xFFF8F9FA);

    final recipeState = ref.watch(recipeProvider);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          // ✅ 수정 포인트: 스택이 없으면 명시적으로 수정 화면으로 이동합니다.
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/edit-ingredients');
            }
          },
        ),
      ),
      body: recipeState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: primaryGreen),
        ),
        error: (error, stack) => Center(
          child: Text('에러가 발생했습니다: $error'),
        ),
        data: (response) {
          final recipes = response?.recipes ?? [];

          if (recipes.isEmpty) {
            return _buildEmptyState(primaryGreen);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '찾은 레시피',
                      style: TextStyle(fontSize: 14, color: primaryGreen, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '총 ${recipes.length}개의 요리 추천',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // ✅ 수정 포인트: 리스트가 길어질 수 있으므로 스크롤바를 추가했습니다.
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 4.0,
                  radius: const Radius.circular(10),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return _buildRecipeCard(context, recipe, primaryGreen);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(primaryGreen, context),
    );
  }

  // --- 위젯 빌더들은 기존과 동일하게 유지하되, 리포지토리 패턴에 맞춰 다듬었습니다. ---

  Widget _buildRecipeCard(BuildContext context, dynamic recipe, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/detail', extra: recipe),
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    recipe.thumbnailUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.restaurant)),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${recipe.matchRate.toInt()}% 일치',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoTag(Icons.speed, recipe.difficulty),
                      const SizedBox(width: 12),
                      _buildInfoTag(Icons.access_time, recipe.estimatedTime),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyState(Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('조건에 맞는 레시피가 없어요', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            // ✅ 재검색 시 수정 화면으로 다시 보내주는 기능을 넣으면 좋습니다.
            onPressed: () => context.go('/edit-ingredients'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('다시 재료 수정하기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color primaryColor, BuildContext context) {
    return Container(
      height: 100,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
            ),
          ),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: () => context.go('/home'),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: const Icon(Icons.home_filled, color: Colors.white, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}