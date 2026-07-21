import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PhuongTienApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<PhuongTien>> getDsPhuongTienByNguoiThue(int idnt) async {
    try {
      final response = await _dio.get("phuong-tien/nguoi-thue/$idnt");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => PhuongTien.fromMap(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi PhuongTienApiClient khi lấy ds xe: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định PhuongTienApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại!");
    }
  }
  Future<PhuongTien> createPhuongTien(PhuongTien xe) async {
    try {
      final response = await _dio.post(
        "phuong-tien",
        data: xe.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhuongTien.fromMap(response.data);
      }
      throw Exception("Tạo phương tiện thất bại!");
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi ApiClient createPhuongTien: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      throw Exception("Không thể thêm phương tiện, vui lòng thử lại!");
    }
  }
  Future<PhuongTien> updatePhuongTien(num id, PhuongTien xe) async {
    try {
      final response = await _dio.patch(
        "phuong-tien/$id",
        data: xe.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhuongTien.fromMap(response.data);
      }
      throw Exception("Cập nhật phương tiện thất bại!");
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi ApiClient updatePhuongTien: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      throw Exception("Không thể cập nhật phương tiện, vui lòng thử lại!");
    }
  }
  Future<PhuongTien> deletePhuongTien(num id) async {
    try {
      final response = await _dio.delete("phuong-tien/$id");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhuongTien.fromMap(response.data);
      }
      throw Exception("Xóa phương tiện thất bại!");
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi ApiClient deletePhuongTien: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      throw Exception("Không thể xóa phương tiện, vui lòng thử lại!");
    }
  }

  String _mapErrorToMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return "Không thể kết nối đến máy chủ, vui lòng thử lại sau!";
    }

    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Kết nối mạng quá chậm, vui lòng kiểm tra lại đường truyền!";
    }
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 404:
        return "Lỗi máy chủ, vui lòng thử lại sau";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }
}