import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/HoaDonTapHoaDTO.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HoaDonTapHoaApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<HoaDonTapHoaModel>> getListHoaDonTapHoa() async {
    try {
      final response = await _dio.get("hoa-don-tap-hoa/findAll");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => HoaDonTapHoaModel.fromMap(json)).toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi HoaDonTapHoaApiClient $e");
      }
      rethrow;
    }
  }

  Future<HoaDonTapHoaDTO?> themHoaDonTapHoa(HoaDonTapHoaDTO hoaDon) async {
    try {
      final response = await _dio.post("hoa-don-tap-hoa", data: hoaDon.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          return HoaDonTapHoaDTO.fromMap(response.data);
        }
      }

      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi HoaDonTapHoaApiClient");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định HoaDonTapHoaApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<bool> xoaHoaDonTapHoa(String maHoaDon) async {
    try {
      final response = await _dio.delete("hoa-don-tap-hoa/$maHoaDon");

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi xóa hóa đơn tạp hóa $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định HoaDonTapHoaApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<HoaDonTapHoaDTO?> capNhatHoaDonTapHoa(
    HoaDonTapHoaDTO hoaDonTapHoaDTO,
  ) async {
    try {
      final response = await _dio.patch(
        "hoa-don-tap-hoa/${hoaDonTapHoaDTO.maHoaDon}",
        data: hoaDonTapHoaDTO.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HoaDonTapHoaDTO.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi cập nhật hóa đơn tạp hóa $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định HoaDonTapHoaApiClient: $e");
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

    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 404:
        return "Không tìm thấy dữ liệu";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    }
  }
}
