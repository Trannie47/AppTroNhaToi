import 'dart:io';

import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:dio/dio.dart';

import '../../models/hoa_don_phong.dart';

class HoaDonPhongApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<Map<String, dynamic>> getHoaDonInitData({
    required int phongId,
    required String thangNam,
  }) async {
    try {
      final response = await _dio.get(
        '/hoa-don-phong/init-data',
        queryParameters: {'phongId': phongId, 'thangNam': thangNam},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<List<HoaDonPhong>> createHoaDonPhongBatch({
    required int phongId,
    required String thangNam,
    String? ngayLap,
    bool isChotDienNuoc = false,
    int? chiSoDienCu,
    int? chiSoDienMoi,
    int? chiSoNuocCu,
    int? chiSoNuocMoi,
    double tienDichVuKhac = 0,
    String? ghiChu,
    String? danhSachHopDongJson,
    File? anhDienMoi,
    File? anhNuocMoi,
  }) async {
    try {
      final Map<String, dynamic> mapData = {
        'phongId': phongId,
        'thangNam': thangNam,
        'isChotDienNuoc': isChotDienNuoc,
        'tienDichVuKhac': tienDichVuKhac,
        if (ngayLap != null) 'ngayLap': ngayLap,
        if (chiSoDienCu != null) 'chiSoDienCu': chiSoDienCu,
        if (chiSoDienMoi != null) 'chiSoDienMoi': chiSoDienMoi,
        if (chiSoNuocCu != null) 'chiSoNuocCu': chiSoNuocCu,
        if (chiSoNuocMoi != null) 'chiSoNuocMoi': chiSoNuocMoi,
        if (ghiChu != null) 'ghiChu': ghiChu,
        if (danhSachHopDongJson != null)
          'danhSachHopDongJson': danhSachHopDongJson,
      };

      if (anhDienMoi != null) {
        mapData['anhDienMoi'] = await MultipartFile.fromFile(
          anhDienMoi.path,
          filename: anhDienMoi.path.split('/').last,
        );
      }

      if (anhNuocMoi != null) {
        mapData['anhNuocMoi'] = await MultipartFile.fromFile(
          anhNuocMoi.path,
          filename: anhNuocMoi.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(mapData);

      final response = await _dio.post('/hoa-don-phong/create', data: formData);

      final resData = response.data;
      if (resData['success'] == true && resData['data'] != null) {
        final List rawList = resData['data'] as List;
        return rawList.map((item) => HoaDonPhong.fromMap(item)).toList();
      } else {
        throw Exception(resData['message'] ?? 'Tạo hóa đơn thất bại!');
      }
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<List<Map<String, dynamic>>> getDanhSachByPhong({
    required int phongId,
    String? thangNam,
  }) async {
    try {
      final response = await _dio.get(
        '/hoa-don-phong/by-phong/$phongId',
        queryParameters: {if (thangNam != null) 'thangNam': thangNam},
      );
      final List rawList = response.data as List;
      return rawList.map((e) => e as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<Map<String, dynamic>> getChiTietHoaDon({
    required String maHoaDon,
  }) async {
    try {
      final response = await _dio.get('/hoa-don-phong/detail/$maHoaDon');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<bool> deleteHoaDonPhong({required String maHoaDon}) async {
    try {
      final response = await _dio.delete('/hoa-don-phong/$maHoaDon');
      final resData = response.data;
      if (resData['success'] == true) {
        return true;
      } else {
        throw Exception(resData['message'] ?? 'Xóa hóa đơn thất bại!');
      }
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<List<Map<String, dynamic>>> getTatCaHoaDonQuanLy({
    String? thangNam,
  }) async {
    try {
      final response = await _dio.get(
        '/hoa-don-phong/quan-ly-chung',
        queryParameters: {
          if (thangNam != null && thangNam != "Tất cả") 'thangNam': thangNam,
        },
      );
      final resData = response.data;
      if (resData['success'] == true && resData['data'] != null) {
        final List rawList = resData['data'] as List;
        return rawList.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
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
        return "Không tìm thấy dữ liệu!";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau!";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại!";
    }
  }
}
