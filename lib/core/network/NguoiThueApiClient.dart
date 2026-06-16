import 'dart:convert';
import 'dart:ffi';

import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NguoiThueApiClient {
  final Dio _dio= RetrofitClient().dio;
  
  Future<List<NguoiThue>> getListNguoiThue() async{
    try{
      final response= await _dio.get("nguoi-thue/findall");
      if(response.statusCode ==200 || response.statusCode==201){
        final List<dynamic> data= response.data;
        return data.map((json)=> NguoiThue.fromMap(json)).toList();
      }
      return [];
    }catch(e){
      if (kDebugMode) {
        print("Loi NguoiThueApiClient $e");
      }
      return [];
    }
  }

  Future<bool> themNguoiThue(NguoiThue nguoiThue) async {
    try {
     final result= await _dio.post(
        "nguoi-thue/create",
        data: nguoiThue.toMap(),
      );
     if(result.statusCode==200 || result.statusCode==201){
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
  Future<bool> xoaNguoiThue(int idnt) async{

    try{
      final response= await _dio.delete("nguoi-thue/$idnt");
      if(response.statusCode==200|| response.statusCode==201){
        return true;
      }
      return false;
    }catch(e){
      if (kDebugMode) {
        print('Lỗi xóa người thuê $e');
      }
      rethrow;
    }
  }
}