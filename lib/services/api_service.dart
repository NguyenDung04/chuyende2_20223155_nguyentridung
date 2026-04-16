import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/exceptions/app_exception.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<dynamic>> getPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['posts'] as List<dynamic>;
      } else {
        throw ServerException('API lỗi: ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } on FormatException {
      throw AppException('Dữ liệu trả về không hợp lệ');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Đã xảy ra lỗi: $e');
    }
  }
}