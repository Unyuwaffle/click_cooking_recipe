// This file manages the state of the recipe API call

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/recipe_model.dart'; // From Week 2, Step 3
import 'api_provider.dart'; // From Week 2, Step 4

// (1) The main provider that manages the async state
// The UI (FE2) will 'watch' this provider
final recipeProvider =
AsyncNotifierProvider<RecipeNotifier, RecipeResponse?>(
  RecipeNotifier.new,
);

// (2) The Notifier class that holds the logic
class RecipeNotifier extends AsyncNotifier<RecipeResponse?> {

  @override
  Future<RecipeResponse?> build() {
    // Return null for the initial state (no data yet)
    return Future.value(null);
  }

  // --- This is the key function for FE1 ---
  // This function will be called from CameraScreen
  Future<void> fetchRecipes(File image) async {
    // 1. Set state to loading
    state = const AsyncLoading();

    // 2. Read the ApiService from the provider we made in Week 2
    final apiService = ref.read(apiServiceProvider);

    // 3. Call the API and update the state
    // AsyncValue.guard handles try/catch for us
    state = await AsyncValue.guard(
          () => apiService.recommendRecipes(image),
    );
  }
}

// (3) The global loading provider (Task 3 from plan)
// This provider simply checks if recipeProvider is in a loading state.
// FE2 can watch this to show the LoadingIndicator.
final isLoadingProvider = Provider<bool>((ref) {
  final recipeState = ref.watch(recipeProvider);
  return recipeState.isLoading;
});