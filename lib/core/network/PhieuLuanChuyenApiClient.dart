import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/HopDongLuanChuyenVM.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/PhongHopDongVM.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PhieuLuanChuyenApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<PhieuLuanChuyen>> getAll() async {
    try {
      final response = await _dio.get("phieu-luan-chuyen/findall");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => PhieuLuanChuyen.fromMap(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ChiTietLuanChuyenApiClient $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ChiTietLuanChuyenApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<List<HopDongLuanChuyenVM>> getBySuCo(int suCoId) async {
    try {
      final response = await _dio.get(
        "phieu-luan-chuyen/find-by-su-co",
        queryParameters: {"suCoId": suCoId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => HopDongLuanChuyenVM.fromMap(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ChiTietLuanChuyenApiClient $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ChiTietLuanChuyenApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<PhieuLuanChuyen?> themChiTietLuanChuyen(
    PhieuLuanChuyen chiTiet,
  ) async {
    try {
      final response = await _dio.post(
        "phieu-luan-chuyen",
        data: chiTiet.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhieuLuanChuyen.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<PhieuLuanChuyen?> capNhatChiTietLuanChuyen(
    PhieuLuanChuyen chiTiet,
  ) async {
    try {
      final response = await _dio.patch(
        "phieu-luan-chuyen/${chiTiet.chiTietLuanChuyenID}",
        data: chiTiet.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhieuLuanChuyen.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<bool> xoaChiTietLuanChuyen(int id) async {
    try {
      final response = await _dio.delete("phieu-luan-chuyen/$id");

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
