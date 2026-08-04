import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/NguoiThueAvailableDTO.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThuCongNoForm/thuCongNoFormModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NguoiThueApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<NguoiThue>> getListNguoiThue() async {
    try {
      final response = await _dio.get("nguoi-thue/findall");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => NguoiThue.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Loi NguoiThueApiClient $e");
      }
      return [];
    }
  }

  Future<bool> themNguoiThue(NguoiThue nguoiThue) async {
    try {
      final result = await _dio.post(
        "nguoi-thue/create",
        data: nguoiThue.toMap(),
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Loi them nguoi thue $e");
      }

      return false;
    }
  }

  Future<bool> xoaNguoiThue(int idnt) async {
    try {
      final response = await _dio.delete("nguoi-thue/$idnt");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi xóa người thuê $e');
      }
      rethrow;
    }
  }

  Future<NguoiThue?> updateNguoiThue(int idnt, NguoiThue nguoiThue) async {
    try {
      final response = await _dio.patch(
        "nguoi-thue/$idnt",
        data: nguoiThue.toMap(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NguoiThue.fromMap(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi tầng NguoiThueApiClient khi cập nhật: $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định tại NguoiThueApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  // lấy ds người thuê có trạng thái 0 or 1 lên màn tạo hợp đồng
  Future<List<NguoiThue>> getNguoiThueAvailableForContract() async {
    try {
      final response = await _dio.get(
        "nguoi-thue/nguoiThueAvailableForContract",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => NguoiThue.fromMap(json)).toList();
      }
      throw Exception(
        "Lấy ds người thuê avalable thất bại (Mã lỗi: ${response.statusCode}",
      );
    } catch (e) {
      if (kDebugMode) {
        print(
          "Loi getNguoiThueAvailableForContract trong NguoiThueApiClient $e",
        );
      }
      rethrow;
    }
  }

  Future<List<NguoiThueAvailableDTO>> getAvailableRepresentatives({
    DateTime? ngayKy,
  }) async {
    final response = await _dio.get(
      "nguoi-thue/available-representatives",
      queryParameters: {if (ngayKy != null) 'ngayKy': _formatDateOnly(ngayKy)},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      return data.map((json) => NguoiThueAvailableDTO.fromJson(json)).toList();
    }
    throw Exception(
      "Lấy ds người đại diện thất bại (Mã lỗi: ${response.statusCode})",
    );
  }

  Future<List<NguoiThueAvailableDTO>> getAvailableMembers({
    int? excludeIdnt,
  }) async {
    final response = await _dio.get(
      "nguoi-thue/available-members",
      queryParameters: {if (excludeIdnt != null) 'excludeIdnt': excludeIdnt},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      return data.map((json) => NguoiThueAvailableDTO.fromJson(json)).toList();
    }
    throw Exception(
      "Lấy ds thành viên thất bại (Mã lỗi: ${response.statusCode})",
    );
  }

  // Gọi API backend để lấy danh sách người thuê còn công nợ tạp hóa.
  Future<List<ThuCongNoFormModel>> getNguoiThueCongNoTapHoa() async {
    try {
      final response = await _dio.get("nguoi-thue/cong-no-tap-hoa");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;

        return data.map((json) => ThuCongNoFormModel.fromMap(json)).toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi getNguoiThueCongNoTapHoa: $e");
      }
      return [];
    }
  }

  Future<List<NguoiThue>> getListNguoiThueFromIdPhong(int idPhong) async {
    try {
      final response = await _dio.get("phong/$idPhong/getListNguoiThue");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => NguoiThue.fromMap(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi tầng NguoiThueApiClient $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định, NguoiThueApiClient");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  String _formatDateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
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
