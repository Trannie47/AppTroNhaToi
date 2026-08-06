import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/phieu_su_co.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SuCoApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<PhieuSuCo>> getListSuCo() async {
    try {
      final response = await _dio.get("phieu-su-co/findall");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data
            .map((json) => PhieuSuCo.fromMap(json))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi SuCoApiClient $e");
      }

      return [];
    }
  }

  Future<List<PhieuSuCo>> getListSuCoTheoPhong(
      int phongId,
      ) async {
    try {
      final response = await _dio.get(
        "phieu-su-co/findall",
        queryParameters: {
          "phongId": phongId,
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final List<dynamic> data =
        response.data["data"];

        return data
            .map((e) => PhieuSuCo.fromMap(e))
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<PhieuSuCo?> themSuCo(PhieuSuCo suCo) async {
    try {
      final response = await _dio.post(
        "phieu-su-co",
        data: suCo.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhieuSuCo.fromMap(response.data["data"]);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi thêm sự cố $e");
      }

      return null;
    }
  }

  Future<bool> xoaSuCo(int suCoId) async {
    try {
      final response = await _dio.delete(
        "phieu-su-co/$suCoId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi xóa sự cố $e");
      }

      rethrow;
    }
  }

  Future<PhieuSuCo?> capNhatSuCo(PhieuSuCo suCo) async {
    try {
      final response = await _dio.patch(
        "phieu-su-co/${suCo.suCoId}",
        data: suCo.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhieuSuCo.fromMap(response.data["data"]);
      }

      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi tầng SuCoApiClient $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định SuCoApiClient");
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

    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 404:
        return "Không tìm thấy dữ liệu";

      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";

      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }

  Future<Map<String, dynamic>> getLuanChuyen(int suCoId) async {
    try {
      final response = await _dio.get(
        "phieu-su-co/$suCoId/luan-chuyen",
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return response.data["data"];
      }

      return {};
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return {};
    }
  }
  Future<void> luuLuanChuyen(
      Map<String, dynamic> body,
      ) async {
    try {
      final response = await _dio.post(
        "chi-tiet-luan-chuyen",
        data: body,
      );

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Data: ${response.data}");
    } on DioException catch (e) {
      debugPrint("STATUS = ${e.response?.statusCode}");
      debugPrint("BODY = ${e.response?.data}");
      rethrow;
    }
  }
}