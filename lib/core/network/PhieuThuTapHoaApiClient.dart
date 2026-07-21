import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/ThuCongNoDTO.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PhieuThuTapHoaApiClient {
  final Dio _dio = RetrofitClient().dio;
}
