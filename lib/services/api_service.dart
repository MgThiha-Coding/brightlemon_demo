import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio;
  
  ApiService() : _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get('API_BASE_URL', fallback: 'https://api.example.com'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      rethrow;
    }
  }
}

class ImageService {
  static String getPicsum(int id, {int w = 800, int h = 600}) {
    return 'https://picsum.photos/id/$id/$w/$h';
  }
}
