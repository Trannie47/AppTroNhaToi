import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SuaChuaApiClient {
  final Dio _dio = RetrofitClient().dio;

  /// Lấy tất cả sửa chữa
  Future<List<SuaChua>> getAll() async {
    try {
      final response = await _dio.get("sua-chua");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => SuaChua.fromMap(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi SuaChuaApiClient: $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định SuaChuaApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  /// Lấy sửa chữa theo ID
  Future<SuaChua?> getById(int id) async {
    try {
      final response = await _dio.get("sua-chua/$id");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuaChua.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  /// Lấy danh sách sửa chữa theo thiết bị
  Future<List<LichSuSuaChuaPageModel>> getTheoThietBi(int thietBiID) async {
    try {
      final response = await _dio.get("sua-chua/thiet-bi/$thietBiID");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data
            .map((json) => LichSuSuaChuaPageModel.fromMap(json))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi SuaChuaApiClient: $e");
      }

      throw Exception(_mapErrorToMessage(e));
    }
  }

  /// Thêm sửa chữa
  Future<SuaChuaDTO?> themSuaChua(SuaChuaDTO suaChua) async {
    try {
      final response = await _dio.post("sua-chua", data: suaChua.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuaChuaDTO.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  /// Cập nhật sửa chữa
  Future<SuaChuaDTO?> capNhatSuaChua(SuaChuaDTO suaChua) async {
    try {
      final response = await _dio.patch(
        "sua-chua/${suaChua.id}",
        data: suaChua.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuaChuaDTO.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      print('DEBUG DioException type: ${e.type}');
      print('DEBUG DioException message: ${e.message}');
      print('DEBUG DioException response: ${e.response}');
      print('DEBUG DioException requestOptions.path: ${e.requestOptions.path}');
      print(
        'DEBUG DioException requestOptions.baseUrl: ${e.requestOptions.baseUrl}',
      );
      throw Exception(_mapErrorToMessage(e));
    }
  }

  /// Xóa sửa chữa
  Future<bool> xoaSuaChua(int id) async {
    try {
      final response = await _dio.delete("sua-chua/$id");

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
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
