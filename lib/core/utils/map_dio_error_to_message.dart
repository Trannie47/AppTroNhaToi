import 'package:dio/dio.dart';

String mapDioErrorToMessage(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.connectionError) {
    return "Không thể kết nối đến máy chủ, vui lòng thử lại sau!";
  }

  if (e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return "Kết nối mạng quá chậm, vui lòng kiểm tra lại đường truyền!";
  }

  if (e.type == DioExceptionType.badResponse || e.response != null) {
    final responseData = e.response?.data;

    if (responseData is Map<String, dynamic>) {
      final msg = responseData['message'];
      if (msg is String) return msg;

      if (msg is List && msg.isNotEmpty) return msg.first.toString();
    }
  }

  final statusCode = e.response?.statusCode;
  switch (statusCode) {
    case 400:
      return "Dữ liệu yêu cầu không hợp lệ";
    case 401:
      return "Phiên làm việc hết hạn, vui lòng đăng nhập lại!";
    case 403:
      return "Bạn không có quyền thực hiện hành động này!";
    case 404:
      return "Không tìm thấy dữ liệu yêu cầu!";
    case 500:
      return "Hệ thống đang gặp sự cố, vui lòng thử lại sau!";
    default:
      return "Đã có lỗi xảy ra, vui lòng thử lại sau!";
  }
}