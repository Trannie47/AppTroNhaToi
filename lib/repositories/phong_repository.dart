import 'package:AppTroNhaToi/core/network/PhongApiClient.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';

import '../models/phong.dart';

class PhongRepository {
 final PhongApiClient _phongApiClient= PhongApiClient();


  Future<List<ItemPhong>> fetchPhong() async{
    return await _phongApiClient.fetchListPhong();
  }
  Future<Phong?> saveRoom(Phong room) async{
    return await _phongApiClient.SaveRoom(room);
  }

  Future<Phong?> updateRoom(Phong room) async{
    return await _phongApiClient.updateRoom(room);
  }
}