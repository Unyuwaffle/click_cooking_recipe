import 'package:dio/dio.dart';
import 'dart:io';

// Import the model created in Step 3
import '../models/recipe_model.dart';

class ApiService {

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://220.70.152.54:8000/api/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // --- MODIFICATION HERE ---
  // Change return type from Future<Map<String, dynamic>>
  // to Future<RecipeResponse>
  Future<RecipeResponse> recommendRecipes(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/recipes/recommend',
        data: formData,
      );

      if (response.statusCode == 200) {
        // --- MODIFICATION HERE ---
        // Convert the raw JSON (response.data) into our RecipeResponse object
        // using the fromJson factory we created in Step 3.
        return RecipeResponse.fromJson(response.data);
      } else {
        throw Exception('Server returned an error: ${response.statusCode}');
      }

    } on DioException catch (e) {
      // Handle Dio errors (timeout, no connection, 404, 500)

      // Check if the error is a response from the server (like 400, 404, 500)
      if (e.response != null && e.response!.data != null) {
        // Try to parse the error message from BE (based on our API spec)
        try {
          final String errorMessage = e.response!.data['message'];
          throw Exception(errorMessage); // Throw the *specific* error from BE
        } catch (_) {
          // If BE's error format is wrong, throw a generic server error
          throw Exception('An error occurred on the server.');
        }
      } else {
        // This handles connection errors (no internet, timeout, server down)
        throw Exception('Failed to connect to the server. Check your network.');
      }
    } catch (e) {
      // Handle other parsing errors
      print('UnknownError: $e');
      throw Exception('An unknown error occurred: $e');
    }
  }
}