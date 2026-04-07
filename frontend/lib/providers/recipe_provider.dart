// lib/providers/recipe_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
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

  /// [1단계] 이미지 인식 요청 (수정 화면 진입 전)
  Future<void> recognizeIngredientsOnly(File image) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final apiService = ref.read(apiServiceProvider);
      return await apiService.recommendRecipes(image);
    });
  }

  /// [3단계] 유저가 수정한 재료 리스트로 최종 레시피 검색
  Future<void> fetchRecipesWithList(List<String> editedIngredients) async {
    state = const AsyncLoading(); // 로딩 상태로 전환하여 결과 화면에서 스피너가 돌게 함
    state = await AsyncValue.guard(() async {
      final apiService = ref.read(apiServiceProvider);
      // 서버의 /api/v1/recipes/search 엔드포인트 호출
      return await apiService.getRecipesByList(editedIngredients);
    });
  }
}