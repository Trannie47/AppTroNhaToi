import 'dart:io';
import 'package:dio/dio.dart';
import '../../models/phieuthu_diennuoc.dart';
import 'retrofit_client.dart';

class PhieuThuDienNuocApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<PhieuThuDienNuoc> createPhieuThuDienNuoc({
    required int phongId,
    required String thangNam,
    required int lanGhi,
    required double soTien,
    String? ghiChu,
  }) async {
    try {
      final response = await _dio.post(
        '/phieu-thu-dien-nuoc/create',
        data: {
          'phongId': phongId,
          'thangNam': thangNam,
          'lanGhi': lanGhi,
          'soTien': soTien,
          if (ghiChu != null && ghiChu.isNotEmpty) 'ghiChu': ghiChu,
        },
      );

      final resData = response.data;
      if (resData['success'] == true && resData['data'] != null) {
        return PhieuThuDienNuoc.fromMap(resData['data']);
      } else {
        throw Exception(
          resData['message'] ?? 'Lập phiếu thu điện nước thất bại!',
        );
      }
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<bool> removePhieuThuDienNuoc({
    required int phongId,
    required String thangNam,
    required int lanGhi,
  }) async {
    try {
      final response = await _dio.delete(
        '/phieu-thu-dien-nuoc/remove',
        queryParameters: {
          'phongId': phongId,
          'thangNam': thangNam,
          'lanGhi': lanGhi,
        },
      );

      final resData = response.data;
      if (resData['success'] == true) {
        return true;
      } else {
        throw Exception(
          resData['message'] ?? 'Xóa hóa đơn điện nước thất bại!',
        );
      }
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  String _mapErrorToMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return "Không thể kết nối đến máy chủ, vui lòng thử lại sau!";
    }
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    return "Đã có lỗi xảy ra, vui lòng thử lại!";
  }
}
