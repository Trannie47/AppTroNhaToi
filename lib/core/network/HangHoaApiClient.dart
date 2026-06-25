import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HangHoaApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<HangHoa>> getListHangHoa() async {
    try {
      final response = await _dio.get("hang-hoa/findall");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => HangHoa.fromMap(json)).toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi HangHoaApiClient $e");
      }

      return [];
    }
  }

  Future<HangHoa?> themHangHoa(HangHoa hangHoa) async {
    try {
      final response = await _dio.post("hang-hoa", data: hangHoa.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HangHoa.fromMap(response.data);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi thêm hàng hóa $e");
      }

      return null;
    }
  }

  Future<bool> xoaHangHoa(int maHangHoa) async {
    try {
      final response = await _dio.delete("hang-hoa/$maHangHoa");
      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi xóa hàng hóa $e");
      }

      rethrow;
    }
  }

  Future<HangHoa?> capNhatHangHoa(HangHoa hangHoa) async {
    try {
      final response = await _dio.patch(
        "hang-hoa/${hangHoa.maHangHoa}",
        data: hangHoa.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HangHoa.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi tầng HangHoaApiClient $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định HangHoaApiClient");
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
        return "Lỗi máy chủ, vui lòng thử lại sau";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }
}
