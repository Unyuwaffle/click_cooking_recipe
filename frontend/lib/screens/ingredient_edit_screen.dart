// lib/screens/ingredient_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/recipe_provider.dart';

class IngredientEditScreen extends ConsumerStatefulWidget {
  const IngredientEditScreen({super.key});

  @override
  ConsumerState<IngredientEditScreen> createState() => _IngredientEditScreenState();
}

class _IngredientEditScreenState extends ConsumerState<IngredientEditScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    // 초기 로딩 시 서버에서 받은 '인식된 재료' 리스트를 가져옴
    final state = ref.read(recipeProvider).value;
    if (state != null) {
      _ingredients = List.from(state.recognizedIngredients);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1E6027);
    const accentOrange = Color(0xFFE67E22);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Click Cooking Recipe',
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.5),
        ),
        centerTitle: true,
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 4.0,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('식재료 분석 완료', style: TextStyle(color: accentOrange, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('인식된 식재료', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 30),
              // 리스트 렌더링
              ..._ingredients.asMap().entries.map((entry) {
                return _buildIngredientCard(entry.value, () => setState(() => _ingredients.removeAt(entry.key)));
              }).toList(),
              const SizedBox(height: 10),
              _buildAddButton(),
              const SizedBox(height: 40),
              _buildSearchButton(primaryGreen),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryGreen),
    );
  }

  Widget _buildIngredientCard(String name, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15)]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.restaurant, color: Colors.orange, size: 28)),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: onRemove,
            style: TextButton.styleFrom(backgroundColor: const Color(0xFFF1F8E9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            child: const Text('삭제', style: TextStyle(color: Color(0xFF1E6027), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ➕ 식재료 추가 팝업 로직 완성
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _showAddDialog(),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.5), borderRadius: BorderRadius.circular(50)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add), SizedBox(width: 8), Text('식재료 추가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]),
      ),
    );
  }

  // 🚀 최종 검색 버튼: 수정된 리스트를 서버로 전송
  Widget _buildSearchButton(Color color) {
    return SizedBox(
      width: double.infinity, height: 60,
      child: ElevatedButton(
        onPressed: () async {
          // 1. 현재 수정된 _ingredients 리스트를 서버로 보내기
          await ref.read(recipeProvider.notifier).fetchRecipesWithList(_ingredients);

          // 2. 서버 응답이 완료된 후(state가 업데이트된 후) 화면 이동
          if (mounted) {
            context.go('/result');
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        child: const Text('레시피 찾기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('식재료 추가'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: '예: 감자, 양파')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _ingredients.add(controller.text));
              }
              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color primaryColor) {
    return Container(
      height: 100, color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(height: 80, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)])),
          Positioned(bottom: 20, child: GestureDetector(onTap: () => context.canPop() ? context.pop() : context.go('/camera'), child: Container(width: 75, height: 75, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12)]), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, color: Colors.white, size: 30), Text('카메라', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))])))),
        ],
      ),
    );
  }
}