// To parse this JSON data, do
//
//     final recipeResponse = recipeResponseFromJson(jsonString);

import 'dart:convert';

RecipeResponse recipeResponseFromJson(String str) => RecipeResponse.fromJson(json.decode(str));

String recipeResponseToJson(RecipeResponse data) => json.encode(data.toJson());

class RecipeResponse {
  List<String> recognizedIngredients;
  List<Recipe> recipes;

  RecipeResponse({
    required this.recognizedIngredients,
    required this.recipes,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => RecipeResponse(
    recognizedIngredients: List<String>.from(json["recognizedIngredients"].map((x) => x)),
    recipes: List<Recipe>.from(json["recipes"].map((x) => Recipe.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "recognizedIngredients": List<dynamic>.from(recognizedIngredients.map((x) => x)),
    "recipes": List<dynamic>.from(recipes.map((x) => x.toJson())),
  };
}

class Recipe {
  int recipeId;
  String title;
  String thumbnailUrl;
  double matchRate;
  String difficulty;
  String estimatedTime;
  List<Ingredient> ingredients;
  List<Step> steps;

  Recipe({
    required this.recipeId,
    required this.title,
    required this.thumbnailUrl,
    required this.matchRate,
    required this.difficulty,
    required this.estimatedTime,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    recipeId: json["recipeId"],
    title: json["title"],
    thumbnailUrl: json["thumbnailUrl"],
    matchRate: json["matchRate"]?.toDouble(),
    difficulty: json["difficulty"],
    estimatedTime: json["estimatedTime"],
    ingredients: List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x))),
    steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "recipeId": recipeId,
    "title": title,
    "thumbnailUrl": thumbnailUrl,
    "matchRate": matchRate,
    "difficulty": difficulty,
    "estimatedTime": estimatedTime,
    "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
    "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
  };
}

class Ingredient {
  String name;
  String amount;
  bool owned;

  Ingredient({
    required this.name,
    required this.amount,
    required this.owned,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    name: json["name"],
    amount: json["amount"],
    owned: json["owned"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
    "owned": owned,
  };
}

class Step {
  int stepNumber;
  String description;

  Step({
    required this.stepNumber,
    required this.description,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    stepNumber: json["stepNumber"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "stepNumber": stepNumber,
    "description": description,
  };
}
