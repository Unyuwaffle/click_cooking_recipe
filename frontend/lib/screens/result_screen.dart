// (lib/screens/result_screen.dart)
// This screen now watches the Riverpod provider (FE1 Week 3).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // (1) Keep Riverpod import

// (2) We no longer need mock data imports
// import 'dart:convert';
// import '../data/mock/mock_data.dart';

import '../data/models/recipe_model.dart'; // (3) We still need the model
import '../providers/recipe_provider.dart';  // (4) Import the provider FE1 made
import '../widgets/loading_indicator.dart'; // (5) Import the loading widget

// (6) Change StatelessWidget to ConsumerWidget (already done, good)
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // (7) Add WidgetRef ref

    // --- THIS IS THE CORE CHANGE (FE1 Week 3) ---
    // We 'watch' the provider. This code will re-run
    // when the state changes (loading -> data or loading -> error)
    final AsyncValue<RecipeResponse?> recipeState = ref.watch(recipeProvider);
    // --- END OF CORE CHANGE ---

    return Scaffold(
      appBar: AppBar(title: const Text('추천 레시피')),

      // (8) Use 'when' to handle all 3 states: loading, error, data
      body: recipeState.when(

        // --- STATE 1: LOADING ---
        // This is shown when the API call is in progress
        loading: () {
          return const LoadingIndicator();
        },

        // --- STATE 2: ERROR ---
        // This is shown if the API call fails
        error: (error, stackTrace) {
          return Center(
            child: Text('오류가 발생했습니다: $error'),
          );
        },

        // --- STATE 3: DATA (SUCCESS) ---
        // This is shown when the API call is successful
        data: (recipeData) {

          // Safety check: Handle the initial null state
          if (recipeData == null) {
            // This state occurs before fetchRecipes() is called
            return const Center(child: Text('레시피를 검색해 주세요.'));
          }

          // --- This is the UI FE2 built in Week 2 ---
          // It now uses the 'recipeData' from the provider
          // instead of the old 'mockData'
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show the recognized ingredients
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 8.0,
                  children: recipeData.recognizedIngredients.map((ingredient) {
                    return Chip(label: Text(ingredient));
                  }).toList(),
                ),
              ),

              // Show the list of recipes
              Expanded(
                child: ListView.builder(
                  itemCount: recipeData.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeData.recipes[index]; // Get one recipe

                    // This is the UI for a single recipe item
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Image.network(
                          recipe.thumbnailUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(recipe.title),
                        subtitle: Text('일치율: ${recipe.matchRate}% | ${recipe.difficulty}'),
                        onTap: () {
                          // TODO (Week 3): Go to detail page
                          // context.go('/result/${recipe.recipeId}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
          // --- End of FE2's UI ---
        },
      ),
    );
  }
}