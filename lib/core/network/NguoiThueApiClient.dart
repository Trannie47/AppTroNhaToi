import 'dart:convert';

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

  Future<void> themNguoiThue(NguoiThue nguoiThue) async {
    try {
      await _dio.post(
        "nguoi-thue/create",
        data: jsonEncode(nguoiThue.toMap()),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Loi them nguoi thue $e");
      }

      rethrow;
    }
  }
}