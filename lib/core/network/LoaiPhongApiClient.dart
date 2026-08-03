import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoaiPhongApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<LoaiPhong>> getListLoaiPhong() async {
    try {
      final response = await _dio.get("loai-phong/getAllLoaiPhong");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => LoaiPhong.fromMap(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print("Lỗi LoaiPhongApiClient");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      print("Lỗi không xác định LoaiPhongApiClient: $e");
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<LoaiPhong?> createLoaiPhong(LoaiPhong loaiPhong) async {
    try {
      //Lấy map dữ liệu từ model ra
      Map<String, dynamic> mapData = loaiPhong.toMap();
      //Ép buộc giá trị gửi đi phải là bool thuần túy (true/false) chứ nếu ko thì nó chuyển sang chuỗi thì bên kia sẽ lỗi
      mapData['isMayLanh'] = loaiPhong.isMayLanh;
      final response = await _dio.post(
        "loai-phong/createLoaiPhong",
        data: mapData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['success'] == true) {
          final Map<String, dynamic> loaiPhongJson = response.data['data'];
          return LoaiPhong.fromMap(loaiPhongJson);
        }
      }
      return null;
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi POST LoaiPhongApiClient: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) print("Lỗi không xác định khi tạo: $e");
      throw Exception("Đã có lỗi xảy ra khi tạo loại phòng");
    }
  }

  Future<LoaiPhong?> updateLoaiPhong(LoaiPhong loaiPhong) async {
    try {
      //Lấy map dữ liệu từ model ra
      Map<String, dynamic> mapData = loaiPhong.toMap();

      //Ép buộc giá trị gửi đi phải là bool để tránh lỗi chuỗi "true"/"false"
      mapData['isMayLanh'] = loaiPhong.isMayLanh;

      final response = await _dio.put(
        "loai-phong/updateLoaiPhong",
        data: mapData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['success'] == true) {
          final Map<String, dynamic> loaiPhongJson = response.data['data'];
          return LoaiPhong.fromMap(loaiPhongJson);
        }
      }
      return null;
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi PUT LoaiPhongApiClient: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) print("Lỗi không xác định khi cập nhật: $e");
      throw Exception("Đã có lỗi xảy ra khi cập nhật loại phòng");
    }
  }

  //Gọi API để ẩn loại phòng dưới hệ thống
  Future<bool> deleteLoaiPhong(int maLoaiPhong) async {
    try {
      final response = await _dio.delete(
        "loai-phong/deleteLoaiPhong/$maLoaiPhong",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['success'] == true) {
          return true;
        }
      }
      return false;
    } on DioException catch (e) {
      if (kDebugMode) print("Lỗi DELETE LoaiPhongApiClient: $e");
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) print("Lỗi không xác định khi ẩn: $e");
      throw Exception("Đã có lỗi xảy ra khi ẩn loại phòng");
    }
  }

  String _mapErrorToMessage(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return "Không thể kết nối đến máy chủ, vui lòng thử lại sau!";
    }

    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Kết nối mạng quá chậm, vui lòng kiểm tra lại đường truyền!";
    }
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 404:
        return "Không tìm thấy danh sách loại phòng";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }
}
