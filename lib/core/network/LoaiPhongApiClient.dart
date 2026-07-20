import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:dio/dio.dart';

class LoaiPhongApiClient{
  final Dio _dio= RetrofitClient().dio;

  Future<List<LoaiPhong>> getListLoaiPhong() async{
    try{
      final response= await _dio.get("loai-phong/getAllLoaiPhong");
      if(response.statusCode==200 || response.statusCode==201){
        final List<dynamic> data= response.data;
        return data.map((json) => LoaiPhong.fromMap(json as Map<String, dynamic>)).toList();      }
      return [];
    }on DioException catch(e){
      print("Lỗi LoaiPhongApiClient");
      throw Exception(_mapErrorToMessage(e));
    }catch(e){
      print("Lỗi không xác định LoaiPhongApiClient: $e");
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }
  String _mapErrorToMessage(DioException e){
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Không có kết nối mạng, vui lòng thử lại";
    }
    final statusCode= e.response?.statusCode;
    switch(statusCode){
      case 404:
        return "Không tìm thấy danh sách loại phòng";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
        default:
          return "Đã có lỗi xảy ra, vui lòng thử lại";

    }
  }
}