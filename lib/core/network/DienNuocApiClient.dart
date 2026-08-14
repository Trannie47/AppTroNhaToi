import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:AppTroNhaToi/core/network/retrofit_client.dart';

import '../../models/dien_nuoc.dart';

class DienNuocApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<Map<String, dynamic>> getInitData(int phongId, String thangNam) async {
    try {
      final response = await _dio.get(
        "dien-nuoc/init",
        queryParameters: {"phongId": phongId, "thangNam": thangNam},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw Exception("Dữ liệu trả về không đúng định dạng.");
        }
      }
      throw Exception(
        "Lỗi khi tải dữ liệu khởi tạo. Mã lỗi: ${response.statusCode}",
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi DienNuocApiClient.getInitData: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định DienNuocApiClient.getInitData: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<Map<String, dynamic>> createDienNuoc(
    DienNuoc dienNuoc, {
    String? anhDienCuPath,
    String? anhDienMoiPath,
    String? anhNuocCuPath,
    String? anhNuocMoiPath,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        "phongId": dienNuoc.phongId,
        "thangNam": dienNuoc.thangNam,
        "chiSoDienCu": dienNuoc.chiSoDienCu,
        "chiSoDienMoi": dienNuoc.chiSoDienMoi,
        "chiSoNuocCu": dienNuoc.chiSoNuocCu,
        "chiSoNuocMoi": dienNuoc.chiSoNuocMoi,
        "ngayGhi": dienNuoc.ngayGhi,
      };

      if (anhDienCuPath != null) {
        dataMap["anhDienCu"] = await MultipartFile.fromFile(anhDienCuPath);
      }
      if (anhDienMoiPath != null) {
        dataMap["anhDienMoi"] = await MultipartFile.fromFile(anhDienMoiPath);
      }
      if (anhNuocCuPath != null) {
        dataMap["anhNuocCu"] = await MultipartFile.fromFile(anhNuocCuPath);
      }
      if (anhNuocMoiPath != null) {
        dataMap["anhNuocMoi"] = await MultipartFile.fromFile(anhNuocMoiPath);
      }

      final formData = FormData.fromMap(dataMap);

      final response = await _dio.post(
        "dien-nuoc/create",
        data: formData,
        options: RetrofitClient.uploadOptions,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw Exception("Dữ liệu trả về không đúng định dạng.");
        }
      }
      throw Exception("Lỗi khi tạo dữ liệu. Mã lỗi: ${response.statusCode}");
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi DienNuocApiClient.createDienNuoc: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định DienNuocApiClient.createDienNuoc: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<Map<String, dynamic>> updateDienNuoc(
    DienNuoc dienNuoc, {
    String? anhDienCuPath,
    String? anhDienMoiPath,
    String? anhNuocCuPath,
    String? anhNuocMoiPath,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        "chiSoDienCu": dienNuoc.chiSoDienCu,
        "chiSoDienMoi": dienNuoc.chiSoDienMoi,
        "chiSoNuocCu": dienNuoc.chiSoNuocCu,
        "chiSoNuocMoi": dienNuoc.chiSoNuocMoi,
        "ngayGhi": dienNuoc.ngayGhi,
      };

      if (anhDienCuPath != null)
        dataMap["anhDienCu"] = await MultipartFile.fromFile(anhDienCuPath);
      if (anhDienMoiPath != null)
        dataMap["anhDienMoi"] = await MultipartFile.fromFile(anhDienMoiPath);
      if (anhNuocCuPath != null)
        dataMap["anhNuocCu"] = await MultipartFile.fromFile(anhNuocCuPath);
      if (anhNuocMoiPath != null)
        dataMap["anhNuocMoi"] = await MultipartFile.fromFile(anhNuocMoiPath);

      final formData = FormData.fromMap(dataMap);

      final response = await _dio.put(
        "dien-nuoc/update",
        data: formData,
        queryParameters: {
          "phongId": dienNuoc.phongId,
          "thangNam": dienNuoc.thangNam,
          "lanGhi": dienNuoc.lanGhi,
        },
        options: RetrofitClient.uploadOptions,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception("Lỗi khi cập nhật dữ liệu.");
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
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
