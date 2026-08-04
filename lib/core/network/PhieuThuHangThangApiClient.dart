import 'package:dio/dio.dart';
import '../../core/network/retrofit_client.dart';
import '../../models/phieu_thu_hang_thang.dart';

class PhieuThuHangThangApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<Map<String, dynamic>> createPhieuThu({
    required String maHoaDon,
    required double soTien,
    String? ghiChu,
  }) async {
    try {
      final response = await _dio.post(
        '/phieu-thu-hang-thang/create',
        data: {
          'maHoaDon': maHoaDon,
          'soTien': soTien,
          if (ghiChu != null && ghiChu.isNotEmpty) 'ghiChu': ghiChu,
        },
      );

      final resData = response.data;
      if (resData['success'] == true && resData['data'] != null) {
        final data = resData['data'];
        return {
          'phieuThu': PhieuThuHangThang.fromMap(data['phieuThu']),
          'hoaDonUpdated': data['hoaDonUpdated'],
        };
      } else {
        throw Exception(resData['message'] ?? 'Lập phiếu thu thất bại!');
      }
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<List<PhieuThuHangThang>> getByMaHoaDon({
    required String maHoaDon,
  }) async {
    try {
      final response = await _dio.get(
        '/phieu-thu-hang-thang/hoa-don/$maHoaDon',
      );
      final resData = response.data;

      if (resData['success'] == true && resData['data'] != null) {
        final listRaw = resData['data'] as List;
        return listRaw.map((e) => PhieuThuHangThang.fromMap(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<Map<String, dynamic>> deletePhieuThu({required int maPhieuThu}) async {
    try {
      final response = await _dio.delete('/phieu-thu-hang-thang/$maPhieuThu');
      final resData = response.data;
      if (resData['success'] == true) {
        return {
          'success': true,
          'message': resData['message'] ?? 'Xóa phiếu thu thành công!',
          'data':
              resData['data'], // Chứa thông tin tính lại nợ sau khi rollback
        };
      } else {
        throw Exception(resData['message'] ?? 'Xóa phiếu thu thất bại!');
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
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Kết nối mạng quá chậm, vui lòng kiểm tra lại đường truyền!";
    }
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    return "Đã có lỗi xảy ra, vui lòng thử lại";
  }
}
