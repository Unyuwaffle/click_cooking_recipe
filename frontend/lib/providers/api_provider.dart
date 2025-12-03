// This file registers our services and providers with Riverpod

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/api_service.dart'; // Import ApiService from Step 2 & 3

// (Provider 1)
// This provider simply creates and exposes the ApiService instance.
// We will use this provider inside other providers to make API calls.
final apiServiceProvider = Provider<ApiService>((ref) {
  // 'ref' allows providers to talk to each other
  return ApiService();
});

// (Provider 2 - This is for the *next* step, 1-month 3-week)
// We will later create another provider (e.g., recipeProvider)
// that 'watches' apiServiceProvider and calls the recommendRecipes method.
// The UI (FE2) will watch *that* provider.