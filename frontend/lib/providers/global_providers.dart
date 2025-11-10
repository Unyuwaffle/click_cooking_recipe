import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_cooking_recipe/services/api_service.dart';



// 1. Loading state provider
// A switch that indicates whether the app is currently 'loading' (true) or not (false).
final isLoadingProvider = StateProvider<bool>((ref) {
  return false; // Default value: not loading
});


// 2. Error state provider
// Indicates whether an 'error' has occurred in the app, and if so, what the 'message' is.
// If there is no error, it holds null; if an error occurs, it holds the error message (String).
final errorProvider = StateProvider<String?>((ref) {
  return null; // Default value: no error
});




final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
