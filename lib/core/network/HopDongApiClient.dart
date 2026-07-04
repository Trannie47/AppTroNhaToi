
import 'dart:convert';

import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HopDongApiClient {
  final Dio _dio= RetrofitClient().dio;


  Future<List<HopDongDTO>> fetchListHopDong() async{
    try{
      final request= await _dio.get("hop-dong/findAll");
      if(request.statusCode==200 || request.statusCode==201) {
        final List<dynamic> data = request.data;
        return data.map((json) =>
            HopDongDTO.fromMap(json as Map<String, dynamic>)).toList();
      }
      throw Exception("Tải danh sách hợp đồng thất bại! (Mã lỗi: ${request.statusCode})");
      } catch (e) {
      if (kDebugMode) {
        print("Loi HopDongApiClient $e");
      }
      rethrow;
    }
  }



  Future<List<HopDong>> fetchRoomByNguoithue(int idnt) async{
    try{
      final resquest= await _dio.get("nguoi-thue/$idnt/listRoomNguoiThue");
      if(resquest.statusCode==200 || resquest.statusCode==201){
        final List<dynamic> data= resquest.data;
        return data.map((json)=> HopDong.fromMap(json as Map<String, dynamic>)).toList();
      }
      throw DioException(
          requestOptions: resquest.requestOptions,
        response: resquest,
        type: DioExceptionType.badResponse
      );
    }catch(e){
      print("Loi HopDongApiCline $e");
      rethrow;
    }
  }
}