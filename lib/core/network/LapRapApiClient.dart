import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LapRapApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<LapRapPageModel>> getThietBiByPhongId(int phongId) async {
    try {
      final response = await _dio.get("thiet-bi/phong/$phongId");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data
            .map(
              (json) => LapRapPageModel.fromMap(json as Map<String, dynamic>),
            )
            .toList();
      }
      throw Exception("Không thể lấy danh sách thiết bị trong phòng");
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi Dio getThietBiByPhongId: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định getThietBiByPhongId: $e");
      }
      if (e is Exception) rethrow;
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<LapRap?> taoLapRap({
    required int phongId,
    required int thietBiId,
    required String ghiChu,
    required DateTime ngayLap,
  }) async {
    try {
      final response = await _dio.post(
        "lap-rap",
        data: {
          "phongId": phongId,
          "thietBiId": thietBiId,
          "ghiChu": ghiChu,
          "ngayLap": ngayLap.toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LapRap.fromMap(response.data as Map<String, dynamic>);
      }
      throw Exception("Không thể thêm thiết bị vào phòng");
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi taoLapRap Dio: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi taoLapRap: $e");
      }
      if (e is Exception) rethrow;
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<LapRap?> capNhatLapRap({
    required int id,
    required String ghiChu,
  }) async {
    try {
      final response = await _dio.patch(
        "lap-rap/$id",
        data: {"ghiChu": ghiChu},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LapRap.fromMap(response.data as Map<String, dynamic>);
      }
      throw Exception("Không thể cập nhật thiết bị");
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi capNhatLapRap Dio: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
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
