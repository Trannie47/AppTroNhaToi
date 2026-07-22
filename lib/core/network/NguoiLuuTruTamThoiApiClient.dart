import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/nguoi_luu_tru_tam_thoi.dart';

class NguoiLuuTruTamThoiApiClient {
  final Dio _dio= RetrofitClient().dio;

  Future<List<NguoiLuuTruTamThoi>> getDanhSachLuuTru({int? idnt}) async {
    try {
      final response = await _dio.get(
        "nguoi-luu-tru-tam-thoi",
        queryParameters: {
          if (idnt != null) "idnt": idnt,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = response.data as List;
        return data
            .map((e) => NguoiLuuTruTamThoi.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi fetchDanhSachLuuTru: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<NguoiLuuTruTamThoi?> createNguoiLuuTru(NguoiLuuTruTamThoi item) async {
    try {
      final response = await _dio.post(
        "nguoi-luu-tru-tam-thoi",
        data: item.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NguoiLuuTruTamThoi.fromMap(
            response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi taoNguoiLuuTru: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<NguoiLuuTruTamThoi?> updateLuuTru(NguoiLuuTruTamThoi item) async {
    if (item.idtt == null) {
      throw Exception("Mã IDTT không hợp lệ");
    }

    try {
      final response = await _dio.patch(
        "nguoi-luu-tru-tam-thoi/${item.idtt}",
        data: item.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NguoiLuuTruTamThoi.fromMap(
            response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi capNhatLuuTru: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<bool> deleteLuuTru(int idtt) async {
    try {
      final response = await _dio.delete("nguoi-luu-tru-tam-thoi/$idtt");
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi xoaLuuTru: $e");
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