class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Không có kết nối mạng hoặc không thể truy cập máy chủ']);
}

class ServerException extends AppException {
  ServerException([super.message = 'Máy chủ đang gặp lỗi']);
}

class AuthException extends AppException {
  AuthException([super.message = 'Thông tin đăng nhập không hợp lệ']);
}