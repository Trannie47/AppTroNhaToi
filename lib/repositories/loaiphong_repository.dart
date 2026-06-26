import 'package:AppTroNhaToi/core/network/LoaiPhongApiClient.dart';
import 'package:AppTroNhaToi/models/loaiphong.dart';

class LoaiPhongRepository{
  final LoaiPhongApiClient loaiPhongApiClient=LoaiPhongApiClient();

  Future<List<LoaiPhong>> getListLoaiPhong() async{
      return await loaiPhongApiClient.getListLoaiPhong();
  }
}