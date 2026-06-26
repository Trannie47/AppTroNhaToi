import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoaPage/chiTietHoaDonTapHoaPage_Model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChiTietTapHoaApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<chiTietHoaDonTapHoaPageModel>> getChiTietTheoMaHoaDon(
    String maHoaDon,
  ) async {
    try {
      print("chi-tiet-tap-hoa/hoa-don/$maHoaDon");
      final response = await _dio.get("chi-tiet-tap-hoa/hoa-don/$maHoaDon");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data
            .map((json) => chiTietHoaDonTapHoaPageModel.fromMap(json))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi ChiTietTapHoaApiClient $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ChiTietTapHoaApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<ChiTietTapHoa?> themChiTietTapHoa(ChiTietTapHoa chiTiet) async {
    try {
      final response = await _dio.post(
        "chi-tiet-tap-hoa",
        data: chiTiet.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChiTietTapHoa.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<ChiTietTapHoa?> capNhatChiTietTapHoa(ChiTietTapHoa chiTiet) async {
    try {
      final response = await _dio.put(
        "chi-tiet-tap-hoa/${chiTiet.maChiTietHoaDon}",
        data: chiTiet.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChiTietTapHoa.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<bool> xoaChiTietTapHoa(int maChiTietHoaDon) async {
    try {
      final response = await _dio.delete("chi-tiet-tap-hoa/$maChiTietHoaDon");

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
