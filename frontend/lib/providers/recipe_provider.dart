// lib/providers/recipe_provider.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/recipe_model.dart';
import 'api_provider.dart';

final recipeProvider = AsyncNotifierProvider<RecipeNotifier, RecipeResponse?>(
  RecipeNotifier.new,
);

class RecipeNotifier extends AsyncNotifier<RecipeResponse?> {
  @override
  Future<RecipeResponse?> build() {
    return Future.value(null);
  }

  /// 1. 이미지 인식 요청 (ResultScreen이 아닌 EditScreen으로 넘어가기 전 호출)
  Future<void> recognizeIngredientsOnly(File image) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final apiService = ref.read(apiServiceProvider);
      return await apiService.recommendRecipes(image);
    });
  }

  /// 2. 수정된 재료 리스트로 최종 레시피 요청
  Future<void> fetchRecipesWithList(List<String> editedIngredients) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final apiService = ref.read(apiServiceProvider);
      return await apiService.getRecipesByList(editedIngredients);
    });
  }
}