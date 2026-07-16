import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/ThongKeDTO.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ThongKeApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<ThongKeDTO?> getThongKe({required int thang, required int nam}) async {
    try {
      final response = await _dio.get(
        "thong-ke",
        queryParameters: {"thang": thang, "nam": nam},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          return ThongKeDTO.fromMap(response.data);
        }
      }

      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ThongKeApiClient: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ThongKeApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  String _mapErrorToMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Kết nối quá chậm, vui lòng thử lại";
    }

    if (e.type == DioExceptionType.connectionError) {
      return "Không thể kết nối đến máy chủ, vui lòng thử lại sau";
    }

    if (e.response?.data != null &&
        e.response?.data is Map<String, dynamic> &&
        e.response?.data['message'] != null) {
      final msg = e.response?.data['message'];

      if (msg is String) return msg;
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
    }

    switch (e.response?.statusCode) {
      case 400:
        return "Yêu cầu không hợp lệ!";
      case 401:
        return "Phiên đăng nhập đã hết hạn!";
      case 404:
        return "Không tìm thấy dữ liệu!";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    }
  }
}
