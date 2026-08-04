import 'package:AppTroNhaToi/core/network/suCoApiClient.dart';
import 'package:AppTroNhaToi/models/phieu_su_co.dart';

class SuCoRepository {
  final SuCoApiClient suCoApiClient = SuCoApiClient();

  Future<List<PhieuSuCo>> getListSuCo() async {
    final result = await suCoApiClient.getListSuCo();
    return result;
  }

  Future<PhieuSuCo?> themSuCo(PhieuSuCo suCo) async {
    return await suCoApiClient.themSuCo(suCo);
  }

  Future<bool> xoaSuCo(int suCoId) async {
    return await suCoApiClient.xoaSuCo(suCoId);
  }

  Future<PhieuSuCo?> capNhatSuCo(PhieuSuCo suCo) async {
    return await suCoApiClient.capNhatSuCo(suCo);
  }
}
