import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ItemNguoiLuanChuyenModel.dart';
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

  /// Lấy danh sách phiếu luân chuyển theo phòng cũ (phòng đang gắn trên hợp đồng).
  Future<List<PhieuLuanChuyen>> getLuanChuyenTheoPhong(int phongId) async {
    try {
      final response = await _dio.get(
        "phieu-luan-chuyen/phong-hop-dong/$phongId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => PhieuLuanChuyen.fromMap(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi getLuanChuyenTheoPhong $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định getLuanChuyenTheoPhong: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  /// Lấy danh sách người đã luân chuyển tới phòng mới (mỗi người 1 dòng,
  /// kèm cờ isNguoiThueChinh — đại diện hay ở ghép).
  Future<List<ItemNguoiLuanChuyenModel>> getLuanChuyenPhongMoi(
    int phongId,
  ) async {
    try {
      final response = await _dio.get("phieu-luan-chuyen/phong-moi/$phongId");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data
            .map((json) => ItemNguoiLuanChuyenModel.fromMap(json))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi getLuanChuyenPhongMoi $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định getLuanChuyenPhongMoi: $e");
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

  Future<bool> capNhatChiTietLuanChuyen(PhieuLuanChuyen chiTiet) async {
    try {
      final response = await _dio.patch(
        "phieu-luan-chuyen/${chiTiet.chiTietLuanChuyenID}",
        data: chiTiet.toMap(),
      );

      return response.statusCode == 200 || response.statusCode == 201;
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
