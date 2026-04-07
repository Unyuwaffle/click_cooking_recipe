// lib/screens/ingredient_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/recipe_provider.dart';
import '../widgets/primary_button.dart';

class IngredientEditScreen extends ConsumerStatefulWidget {
  const IngredientEditScreen({super.key});

  @override
  ConsumerState<IngredientEditScreen> createState() => _IngredientEditScreenState();
}

class _IngredientEditScreenState extends ConsumerState<IngredientEditScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    // 초기 값은 Provider에 저장된 인식 결과를 가져옴
    // (Provider에 recognizedIngredients 상태가 있다고 가정)
    final state = ref.read(recipeProvider).value;
    if (state != null) {
      _ingredients = List.from(state.recognizedIngredients);
    }
  }

  void _addIngredient() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('인식된 재료 확인'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('인식된 재료가 맞나요? 부족한 재료는 추가해 주세요.',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),

            // 재료 입력 필드
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '직접 입력 (예: 양파)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add_circle, size: 40, color: Colors.blue), onPressed: _addIngredient),
              ],
            ),
            const SizedBox(height: 20),

            // 재료 리스트 (Chip 형태)
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _ingredients.asMap().entries.map((entry) {
                  return Chip(
                    label: Text(entry.value),
                    onDeleted: () => _removeIngredient(entry.key),
                    deleteIcon: const Icon(Icons.cancel, size: 18),
                  );
                }).toList(),
              ),
            ),

            PrimaryButton(
              text: '이 재료들로 레시피 찾기',
              onPressed: () {
                // 최종 확정된 재료 리스트를 가지고 레시피 검색 API 호출
                ref.read(recipeProvider.notifier).fetchRecipesWithList(_ingredients);
                context.go('/result');
              },
            ),
          ],
        ),
      ),
    );
  }
}