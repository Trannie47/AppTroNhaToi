import 'package:AppTroNhaToi/core/network/PhongApiClient.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';

class PhongRepository {
 final PhongApiClient _phongApiClient= PhongApiClient();


  Future<List<ItemPhong>> fetchPhong() async{
    return await _phongApiClient.fetchListPhong();
  }
}