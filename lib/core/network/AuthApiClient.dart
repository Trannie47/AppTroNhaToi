import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/user_login.dart';
import 'package:dio/dio.dart';

class AuthApiClient{
  final Dio _dio= RetrofitClient().dio;

  Future<UserData?> loginWithApi({
    String? username,
    String? email,
    required String password,
}) async{
    try{
      final Map<String, dynamic> requestBody={
        'password': password
      };
      if(username!=null && username.isNotEmpty){
        requestBody['username']=username;
      }
      if(email!=null && email.isNotEmpty){
        requestBody['email']=email;
      }
      final response= await _dio.post('auth/login',data: requestBody);
      if(response.statusCode==200|| response.statusCode==201) {
        return UserData.fromJson(response.data);
      }
      return null;
    }on DioException catch(e){
      print("Tầng Api lỗi Dio $e");
      return null;
    }
    catch(e){
      print(" [Tầng API Lỗi Hệ Thống]: $e");
      return null;
    }
  }

}