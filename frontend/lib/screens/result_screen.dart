import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import necessary files
import '../data/models/recipe_model.dart';
import '../providers/recipe_provider.dart'; // Ensure folder name is 'providers'
import '../widgets/loading_indicator.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to rebuild UI on state changes
    final AsyncValue<RecipeResponse?> recipeState = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('추천 레시피')),
      body: recipeState.when(

        // 1. Loading State: Show the spinner
        loading: () => const LoadingIndicator(),

        // 2. Error State: Show a user-friendly error message with icon
        // [FE2 Polish] Replaced simple text with a styled UI
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '레시피를 찾지 못했습니다.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display the specific error message from Backend
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Go back to the previous screen (Camera)
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 시도하기'),
                  )
                ],
              ),
            ),
          );
        },

        // 3. Data (Success) State
        data: (recipeData) {

          // (3-1) Initial Null State: Show a guide UI
          // [FE2 Polish] Replaced simple text with an inviting UI
          if (recipeData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image_search, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '재료 사진을 등록하면\n레시피를 추천해 드려요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // (3-2) Success UI: Display ingredients and recipe list
          // This part reuses the logic from Week 2
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Recognized Ingredients
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[100], // Slight background color
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '인식된 재료',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: recipeData.recognizedIngredients.map((ingredient) {
                        return Chip(
                          label: Text(ingredient),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Section 2: Recipe List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: recipeData.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeData.recipes[index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recipe.thumbnailUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            // Show error icon if image fails to load
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          recipe.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('일치율: ${recipe.matchRate}%'),
                            Text(
                              '난이도: ${recipe.difficulty} | 조리시간: ${recipe.estimatedTime}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to detail page
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}