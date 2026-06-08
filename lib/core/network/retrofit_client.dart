import 'package:AppTroNhaToi/core/constants/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RetrofitClient {
  static final RetrofitClient _instance = RetrofitClient._internal();

  late final Dio _dio;

   RetrofitClient._internal() {
     _dio= Dio(
       BaseOptions(
         baseUrl: HttpConfig.baseUrl,
         connectTimeout: const Duration(seconds: 15),
         receiveTimeout: const Duration(seconds: 15),
         contentType: 'application/json',
         responseType: ResponseType.json,
       ),
     );

     _dio.interceptors.add(
         InterceptorsWrapper(
         onRequest: (options, handler) async {
           const storage= FlutterSecureStorage();
           String? token= await storage.read(key: "KEY_ACCESS_TOKEN");
           if(token !=null && token.isNotEmpty){
             options.headers['Authorization']= 'Bearer $token';
             print("Interceptor Đã đính kèm Token vào Header thành công");
           }
           return handler.next(options);
         },
         onError: (e, handler) {
           return handler.next(e);  
         },
       )
     );
  }

  factory RetrofitClient() => _instance;

  Dio get dio => _dio;

}