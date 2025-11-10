// This is the Mock Data FE2 will use to build the UI

// This is the raw JSON string based on the API spec
const String mockRecipeResponseJson = '''
{
  "recognizedIngredients": ["돼지고기", "양파", "계란"],
  "recipes": [
    {
      "recipeId": 101,
      "title": "초간단 돼지고기 계란 볶음밥",
      "thumbnailUrl": "https://img.freepik.com/free-photo/stir-fried-pork-and-vegetables_1339-5631.jpg?size=626&ext=jpg",
      "matchRate": 90.5,
      "difficulty": "초급",
      "estimatedTime": "20분",
      "ingredients": [],
      "steps": []
    },
    {
      "recipeId": 102,
      "title": "양파 계란국",
      "thumbnailUrl": "https://img.freepik.com/free-photo/traditional-onion-soup_144627-24424.jpg?size=626&ext=jpg",
      "matchRate": 75.0,
      "difficulty": "최하",
      "estimatedTime": "10분",
      "ingredients": [],
      "steps": []
    }
  ]
}
''';