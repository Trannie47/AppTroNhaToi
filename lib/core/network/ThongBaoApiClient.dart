import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../models/thong_bao.dart';

class ThongBaoApiClient {
  final Dio _dio = RetrofitClient().dio;

  /// Lấy tất cả thông báo
  Future<List<ThongBao>> getAllThongBao() async {
    try {
      final response = await _dio.get("thong-bao");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is List) {
          return (response.data as List)
              .map((e) => ThongBao.fromMap(e))
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ThongBaoApiClient: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ThongBaoApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  /// Lấy thông báo chưa đọc
  Future<List<ThongBao>> getThongBaoChuaDoc() async {
    try {
      final response = await _dio.get("thong-bao/chua-doc");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is List) {
          return (response.data as List)
              .map((e) => ThongBao.fromMap(e))
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ThongBaoApiClient: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ThongBaoApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  /// Đánh dấu 1 thông báo là đã đọc
  Future<bool> danhDauDaDoc(int id) async {
    try {
      final response = await _dio.patch("thong-bao/$id/doc");

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ThongBaoApiClient: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ThongBaoApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  /// Đánh dấu tất cả thông báo là đã đọc
  Future<bool> danhDauTatCaDaDoc() async {
    try {
      final response = await _dio.patch("thong-bao/doc-tat-ca");

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ThongBaoApiClient: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ThongBaoApiClient: $e");
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
