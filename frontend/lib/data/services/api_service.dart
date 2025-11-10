import 'package:dio/dio.dart';
import 'dart:io';

// Import the model created in Step 3
import '../models/recipe_model.dart';

class ApiService {

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://[BE_담당자_IP]:8000/api/v1',
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
        throw Exception('Failed to load recipes');
      }

    } on DioException catch (e) {
      // Handle Dio errors (e.g., 404, 500 from BE)
      // We can parse the error response from BE if needed
      print('DioError: ${e.response?.data ?? e.message}');
      throw Exception('Failed to connect to server: ${e.message}');
    } catch (e) {
      // Handle other parsing errors
      print('UnknownError: $e');
      throw Exception('An unknown error occurred: $e');
    }
  }
}