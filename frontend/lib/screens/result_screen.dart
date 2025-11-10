// (lib/screens/result_screen.dart)
// This screen shows the result using MOCK data for now.

import 'package:flutter/material.dart';
import 'dart:convert'; // Import json decoder
import '../data/models/recipe_model.dart'; // Import the model FE1 created
import '../data/mock/mock_data.dart'; // Import the Mock data

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- This is the key part for FE2 ---
    // 1. Parse the mock JSON string
    final Map<String, dynamic> mockData = jsonDecode(mockRecipeResponseJson);

    // 2. Convert the Map into the RecipeResponse object (using the model FE1 made)
    final RecipeResponse recipeData = RecipeResponse.fromJson(mockData);
    // --- End of key part ---

    return Scaffold(
      appBar: AppBar(title: const Text('추천 레시피')),
      body: Column(
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
      ),
    );
  }
}