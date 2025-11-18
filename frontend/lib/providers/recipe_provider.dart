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
    // [NEW] Clear any previous error when a new request starts
    ref.read(recipeErrorProvider.notifier).state = null;

    // 2. Read the ApiService
    final apiService = ref.read(apiServiceProvider);

    // 3. We use a manual try-catch instead of AsyncValue.guard
    //    to gain control over the error object.
    try {
      // 3a. Call the API
      final recipeData = await apiService.recommendRecipes(image);
      
      // 3b. Update state with data on success
      state = AsyncValue.Data(recipeData);

    } catch (e, stackTrace) {
      // 4a. Update state with error
      state = AsyncValue.Error(e, stackTrace);
      
      // 4b. [NEW] Save the error message to our new provider
      // FE1 Task 2 (ApiService) made 'e' contain the pretty message
      ref.read(recipeErrorProvider.notifier).state = e.toString();
    }
  }

// (3) The global loading provider (Task 3 from plan)
// This provider simply checks if recipeProvider is in a loading state.
// FE2 can watch this to show the LoadingIndicator.
final isLoadingProvider = Provider<bool>((ref) {
  final recipeState = ref.watch(recipeProvider);
  return recipeState.isLoading;
});

// (3) The global error provider (Task 3 from plan)
// This provider holds the error message string.
// FE2 can watch this to show a SnackBar.
// It's a StateProvider, meaning it's a simple variable we can set.
final recipeErrorProvider = StateProvider<String?>((ref) {
  return null; // Initial state is no error
});
