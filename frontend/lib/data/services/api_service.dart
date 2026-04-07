// lib/data/services/api_service.dart

import 'package:dio/dio.dart';
import 'dart:io';
import '../models/recipe_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    // TODO: 실제 서버의 IP 주소와 포트로 변경하세요 (예: http://13.125.xx.xx:8000)
    baseUrl: 'http://10.0.2.2:8000/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// [1단계] 사진을 전송하여 서버의 YOLO 모델로부터 재료 목록을 받아옵니다.
  Future<RecipeResponse> recommendRecipes(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
            contentType: DioMediaType.parse("image/jpeg")
        ),
      });

      final response = await _dio.post(
        '/upload', // FastAPI의 이미지 분석 엔드포인트
        data: formData,
      );

      if (response.statusCode == 200) {
        return RecipeResponse.fromJson(response.data);
      } else {
        throw Exception('Server returned an error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  /// [2단계] 사용자가 확정한 재료 리스트를 전송하여 최종 레시피 목록을 받아옵니다.
  Future<RecipeResponse> getRecipesByList(List<String> ingredients) async {
    try {
      final response = await _dio.post(
        '/recipes/search', // FastAPI의 레시피 검색 엔드포인트
        data: {
          "ingredients": ingredients, // JSON body: {"ingredients": ["떡", "어묵"]}
        },
      );

      if (response.statusCode == 200) {
        return RecipeResponse.fromJson(response.data);
      } else {
        throw Exception('Server returned an error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  /// 공통 에러 핸들링 로직 (기존 코드 유지 및 모듈화)
  void _handleDioError(DioException e) {
    if (e.response != null && e.response!.data != null) {
      try {
        final String errorMessage = e.response!.data['message'];
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('서버에서 오류가 발생했습니다.');
      }
    } else {
      throw Exception('서버에 연결할 수 없습니다. 네트워크 상태를 확인해주세요.');
    }
  }
}