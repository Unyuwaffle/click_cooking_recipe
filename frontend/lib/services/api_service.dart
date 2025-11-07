import 'dart:io'; // Import to use the File class
import 'package:dio/dio.dart';

class ApiService {

  // 1. Create a Dio instance
// Declare it as private (_) since it will only be used within this class
  final Dio _dio = Dio();

  
  final String _baseUrl = 'https://vision.api.example.com/v1/';

  
 // (Later, this should be separated using .env or similar, but for now it's temporarily used for testing)

  final String _apiKey = 'YOUR_SUPER_SECRET_API_KEY';

  // 2. Function to send the image and request the ingredient list (core of the test script)
  // The function name and return type are designed to match the 1-month goal of returning an 'ingredient list'
  // For now, returning the raw JSON is fine
  Future<Map<String, dynamic>> getIngredientsFromImage(File imageFile) async {
    // The API endpoint expected by the service (e.g., 'detect-ingredients')
    String endpoint = 'detect-ingredients';
    String fullUrl = _baseUrl + endpoint;

    try {
      // 3. Convert the image to FormData (the format most Vision APIs require)
      String fileName = imageFile.path.split('/').last; // 이미지 파일 이름
      FormData formData = FormData.fromMap({
        // 'image'라는 키 값은 API 문서에서 요구하는 이름으로 변경해야 합니다.
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        // API가 추가 파라미터를 요구하면 여기에 추가
        // 'language': 'ko',
      });

      // 4. Dio POST 요청
      final response = await _dio.post(
        fullUrl,
        data: formData,
        options: Options(
          headers: {
            // API 키를 헤더에 담아 전송 (API 문서 확인 필수)
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // 5. 성공 시 결과 반환 (JSON 형태)
      if (response.statusCode == 200) {
        // 반환된 JSON 데이터를 Map 형태로 파싱하여 반환
        return response.data as Map<String, dynamic>;
      } else {
        // 200 외의 코드는 에러로 간주
        throw Exception('API 요청 실패 (Status code: ${response.statusCode})');
      }
    } on DioException catch (e) {
      // Dio 관련 에러 (네트워크, 타임아웃 등) 처리
      throw Exception('네트워크 에러: ${e.message}');
    } catch (e) {
      // 기타 알 수 없는 에러
      throw Exception('알 수 없는 에러 발생: $e');
    }
  }
}