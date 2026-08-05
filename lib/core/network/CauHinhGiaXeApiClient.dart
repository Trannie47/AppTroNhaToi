import 'package:dio/dio.dart';
import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import '../../models/cau_hinh_gia_xe.dart';

class CauHinhGiaXeApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<CauHinhGiaXe>> getAll() async {
    try {
      final response = await _dio.get('/cau-hinh-gia-xe');
      final List<dynamic> data = response.data;
      return data.map((json) => CauHinhGiaXe.fromMap(json)).toList();
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<CauHinhGiaXe> getByLoaiXe(int loaiXe) async {
    try {
      final response = await _dio.get('/cau-hinh-gia-xe/$loaiXe');
      return CauHinhGiaXe.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<CauHinhGiaXe> update({
    required int loaiXe,
    required double giaMacDinh,
    String? tenLoaiXe,
  }) async {
    try {
      final response = await _dio.post(
        '/cau-hinh-gia-xe',
        data: {
          'loaiXe': loaiXe,
          'giaMacDinh': giaMacDinh,
          if (tenLoaiXe != null) 'tenLoaiXe': tenLoaiXe,
        },
      );
      return CauHinhGiaXe.fromMap(response.data);
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
        return "Lỗi máy chủ, vui lòng thử lại sau";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }
}