import 'dart:convert';

RecipeResponse recipeResponseFromJson(String str) =>
    RecipeResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String recipeResponseToJson(RecipeResponse data) =>
    json.encode(data.toJson());

class RecipeResponse {
  List<String> recognizedIngredients;
  List<Recipe> recipes;

  RecipeResponse({
    required this.recognizedIngredients,
    required this.recipes,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => RecipeResponse(
    recognizedIngredients: List<String>.from(
      (json["recognizedIngredients"] ?? []).map((x) => x.toString()),
    ),
    recipes: List<Recipe>.from(
      (json["recipes"] ?? [])
          .map((x) => Recipe.fromJson(x as Map<String, dynamic>)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "recognizedIngredients":
    List<dynamic>.from(recognizedIngredients.map((x) => x)),
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
  List<RecipeStep> steps;

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
    recipeId: json["recipeId"] ?? 0,
    title: json["title"] ?? "",
    thumbnailUrl: json["thumbnailUrl"] ?? "",
    matchRate: (json["matchRate"] ?? 0).toDouble(),
    difficulty: json["difficulty"] ?? "",
    estimatedTime: json["estimatedTime"] ?? "",
    ingredients: List<Ingredient>.from(
      (json["ingredients"] ?? [])
          .map((x) => Ingredient.fromJson(x as Map<String, dynamic>)),
    ),
    steps: List<RecipeStep>.from(
      (json["steps"] ?? [])
          .map((x) => RecipeStep.fromJson(x as Map<String, dynamic>)),
    ),
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
    name: json["name"] ?? "",
    amount: json["amount"] ?? "",
    owned: json["owned"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
    "owned": owned,
  };
}

class RecipeStep {
  int stepNumber;
  String description;

  RecipeStep({
    required this.stepNumber,
    required this.description,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
    stepNumber: json["stepNumber"] ?? 0,
    description: json["description"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "stepNumber": stepNumber,
    "description": description,
  };
}