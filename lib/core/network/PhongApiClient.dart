import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PhongApiClient {
  final Dio _dio= RetrofitClient().dio;

  Future<List<ItemPhong>> getListPhong() async{
    try{
        final response= await _dio.get("phong/findAll");
        if(response.statusCode==200 || response.statusCode==201){
          final List<dynamic> data= response.data;
          return data.map((json)=> ItemPhong.fromMap(json)).toList();
        }
        return [];
    }catch(e){
      if (kDebugMode) {
        print("Lỗi PhongApiClient $e");
      }
      rethrow;
    }
  }

  Future<Phong?> SaveRoom(Phong room)async{
    try{
      final response= await _dio.post("phong", data: room.toMap());
      if(response.statusCode==200 || response.statusCode==201){
        if(response.data!=null){
          return Phong.fromMap(response.data);
        }
      }
      return null;
    }on DioException catch(e){
      if (kDebugMode) {
        print("Lỗi PhongApiClient");
      }
      throw Exception(_mapErrorToMessage(e));
    }
    catch(e){
      if (kDebugMode) {
        print("Lỗi không xác định PhongApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }
  Future<Phong?> updateRoom(Phong room) async{
    try{
      final response=await _dio.patch("phong/${room.phongID}", data: room.toMap());

      if(response.statusCode==200 || response.statusCode==201){
        if(response.data!=null){
          return Phong.fromMap(response.data);
        }
      }
      return null;
    }on DioException catch(e){
      if (kDebugMode) {
        print("Lỗi PhongApiClient");
      }
      throw Exception(_mapErrorToMessage(e));
    }
    catch(e){
      if (kDebugMode) {
        print("Lỗi không xác định PhongApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }
  Future<Phong?> removePhong(int idPhong) async{
    try{
      final response= await _dio.delete("phong/$idPhong");
      if(response.statusCode==200 || response.statusCode==201){
        if(response.data !=null){
          return Phong.fromMap(response.data);
        }
      }
      return null;
    }on DioException catch(e){
      if (kDebugMode) {
        print("Lỗi tầng PhongApiClient $e");
      }
      throw Exception(_mapErrorToMessage(e));
    }catch(e){
      if (kDebugMode) {
        print("Lỗi không xác định PhongApiClient: $e");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  String _mapErrorToMessage(DioException e){
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Kết nối quá chậm, vui lòng thử lại";
    }
    if (e.type == DioExceptionType.connectionError) {
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
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại sau";
    }
  }
}