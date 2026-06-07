import 'package:AppTroNhaToi/core/constants/http.dart';
import 'package:dio/dio.dart';

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
         onRequest: (options, handler) {
           //code lấy token gửi đi xác minh. chỗ này sẽ gửi kèm đi với mỗi lần gọi api
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