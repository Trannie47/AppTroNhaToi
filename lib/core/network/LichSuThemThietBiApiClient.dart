import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LichSuMuaThietBiApiClient {
  final Dio _dio = RetrofitClient().dio;

  /// Lấy tất cả lịch sử mua
  Future<List<LichSuMuaThietBi>> getAll() async {
    try {
      final response = await _dio.get("lich-su-mua-thiet-bi");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => LichSuMuaThietBi.fromMap(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi LichSuMuaThietBiApiClient: $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định LichSuMuaThietBiApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  /// Lấy theo ID
  Future<LichSuMuaThietBi?> getById(int id) async {
    try {
      final response = await _dio.get("lich-su-mua-thiet-bi/$id");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LichSuMuaThietBi.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  /// Lấy theo thiết bị
  Future<List<LichSuMuaThietBi>> getTheoThietBi(int thietBiID) async {
    try {
      final response = await _dio.get(
        "lich-su-mua-thiet-bi/thiet-bi/$thietBiID",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => LichSuMuaThietBi.fromMap(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi LichSuMuaThietBiApiClient: $e");
      }

      throw Exception(_mapErrorToMessage(e));
    }
  }

  /// Thêm
  Future<LichSuMuaThietBi?> them(LichSuMuaThietBi dto) async {
    try {
      print('LichSuMuaThietBiApiClient');
      print(dto.toMap());
      final response = await _dio.post(
        "lich-su-mua-thiet-bi",
        data: dto.toMap(),
      );
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LichSuMuaThietBi.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  /// Cập nhật
  Future<LichSuMuaThietBi?> capNhat(LichSuMuaThietBi dto) async {
    try {
      final response = await _dio.patch(
        "lich-su-mua-thiet-bi/${dto.id}",
        data: dto.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LichSuMuaThietBi.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DEBUG DioException type: ${e.type}');
        print('DEBUG DioException message: ${e.message}');
        print('DEBUG DioException response: ${e.response}');
      }

      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<bool> xoa(int id) async {
    try {
      final response = await _dio.delete("lich-su-mua-thiet-bi/$id");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ẩn lịch sử mua thiết bị $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định LichSuMuaThietBiApiClient $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }



  String _mapErrorToMessage(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Không có kết nối mạng, vui lòng thử lại";
    }

    switch (e.response?.statusCode) {
      case 404:
        return "Không tìm thấy dữ liệu";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }
}
