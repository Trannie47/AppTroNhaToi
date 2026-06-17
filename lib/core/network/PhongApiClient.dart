import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PhongApiClient {
  final Dio _dio= RetrofitClient().dio;

  Future<List<ItemPhong>> fetchListPhong() async{
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
}