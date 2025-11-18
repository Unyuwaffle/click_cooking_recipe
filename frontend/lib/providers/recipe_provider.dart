import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/recipe_model.dart'; // From Week 2, Step 3
import 'api_provider.dart'; // From Week 2, Step 4

// (1) The main provider
// 이 Provider 하나가 데이터, 로딩, 에러 상태를 모두 관리합니다.
final recipeProvider = AsyncNotifierProvider<RecipeNotifier, RecipeResponse?>(
  RecipeNotifier.new,
);

// (2) The Notifier class
class RecipeNotifier extends AsyncNotifier<RecipeResponse?> {
  @override
  Future<RecipeResponse?> build() {
    // Return null for the initial state (no data yet)
    // 초기 상태는 AsyncValue.Data(null)이 됩니다.
    return Future.value(null);
  }

  // --- This is the key function for FE1 ---
  Future<void> fetchRecipes(File image) async {
    // 1. Set state to loading
    state = const AsyncLoading();

    // 2. AsyncValue.guard를 사용해 API 호출
    // guard는 자동으로 try-catch를 수행하고,
    // 성공 시: state = AsyncValue.Data(결과)
    // 실패 시: state = AsyncValue.Error(에러, 스택)
    // 로 상태를 업데이트해 줍니다.
    state = await AsyncValue.guard(() async {
      final apiService = ref.read(apiServiceProvider);
      final recipeData = await apiService.recommendRecipes(image);
      return recipeData;
    });
  }
}

// (3) [삭제]
// isLoadingProvider와 recipeErrorProvider는 더 이상 필요 없습니다.
// recipeProvider가 이 정보들을 모두 가지고 있습니다.

// final isLoadingProvider = Provider<bool>((ref) { ... }); // <-- 삭제
// final recipeErrorProvider = StateProvider<String?>((ref) { ... }); // <-- 삭제
