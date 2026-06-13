
import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:dio/dio.dart';

class HopDongApiClient {
  final Dio _dio= RetrofitClient().dio;

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