// lib/screens/recipe_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/recipe_model.dart';

class RecipeDetailScreen extends StatefulWidget { // StatefulWidget으로 변경
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // 스크롤바 제어를 위한 컨트롤러 생성
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1E6027);
    const bgColor = Color(0xFFF8F9FA);
    const accentOrange = Color(0xFFE67E22);

    return Scaffold(
      backgroundColor: bgColor,
      // 🎨 스크롤바 추가
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true, // 항상 보이게 설정
        thickness: 4.0, // 얇고 정갈한 두께
        radius: const Radius.circular(10), // 둥근 모서리
        child: CustomScrollView(
          controller: _scrollController, // 스크롤바와 컨트롤러 공유
          slivers: [
            // --- 상단 앱바 영역 ---
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home_outlined, color: Colors.white),
                  onPressed: () => context.go('/home'),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        widget.recipe.thumbnailUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(color: Colors.grey[100], child: const Center(child: CircularProgressIndicator()));
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.restaurant, size: 70, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  widget.recipe.title,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                titlePadding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
              ),
            ),

            // --- 본문 내용 영역 ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 요약 카드
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(Icons.star, '일치율', '${widget.recipe.matchRate.toInt()}%', primaryGreen),
                          _buildVerticalDivider(),
                          _buildSummaryItem(Icons.speed, '난이도', widget.recipe.difficulty, accentOrange),
                          _buildVerticalDivider(),
                          _buildSummaryItem(Icons.access_time, '소요시간', widget.recipe.estimatedTime, Colors.blueGrey),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 식재료 섹션
                    const Text('필요한 재료', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.recipe.ingredients.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3.5,
                      ),
                      itemBuilder: (_, index) {
                        final ing = widget.recipe.ingredients[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: ing.owned ? primaryGreen.withOpacity(0.05) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ing.owned ? primaryGreen.withOpacity(0.2) : Colors.transparent),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                ing.owned ? Icons.check_circle : Icons.remove_circle_outline,
                                color: ing.owned ? primaryGreen : Colors.grey[400],
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${ing.name} (${ing.amount})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: ing.owned ? FontWeight.bold : FontWeight.normal,
                                    color: ing.owned ? Colors.black87 : Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // 조리 순서 섹션
                    const Text('조리 순서', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.recipe.steps.length,
                      itemBuilder: (_, index) {
                        final step = widget.recipe.steps[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: primaryGreen,
                                child: Text('${step.stepNumber}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: Text(step.description, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87))),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String title, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[200]);
  }
}