import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:dio/dio.dart';

import '../../models/hoa_don_gui_xe.dart';

class HoaDonGuiXeApiClient {
  final Dio _dio = RetrofitClient().dio;


  Future<List<HoaDonGuiXe>> getDanhSachHoaDonGuiXe() async {
    try {
      final response = await _dio.get('/hoa-don-gui-xe/getds');
      List rawList = [];

      if (response.data is List) {
        rawList = response.data;
      } else if (response.data is Map && response.data['data'] != null) {
        rawList = response.data['data'];
      }

      return rawList
          .map((item) => HoaDonGuiXe.fromMap(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapErrorToMessage(e);
    } catch (e) {
      throw e.toString();
    }
  }


  String _mapErrorToMessage(DioException e) {
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Kết nối quá chậm, vui lòng thử lại";
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return "Không thể kết nối đến máy chủ, vui lòng thử lại sau";
    }
    if (e.response?.data != null && e.response?.data['message'] != null) {
      final msg = e.response?.data['message'];
      if (msg is String) return msg;
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        return "Dữ liệu yêu cầu không hợp lệ!";
      case 404:
        return "Không tìm thấy dữ liệu yêu cầu!";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    }
  }
}