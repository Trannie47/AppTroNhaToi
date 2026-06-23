import 'package:AppTroNhaToi/core/network/HangHoaApiClient.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';

class HangHoaRepository {
  final HangHoaApiClient hangHoaApiClient = HangHoaApiClient();

  Future<List<HangHoa>> getListHangHoa() async {
    final result = await hangHoaApiClient.getListHangHoa();
    return result;
  }

  Future<HangHoa?> themHangHoa(HangHoa hangHoa) async {
    return await hangHoaApiClient.themHangHoa(hangHoa);
  }

  Future<bool> xoaHangHoa(int maHangHoa) async {
    return await hangHoaApiClient.xoaHangHoa(maHangHoa);
  }

  Future<HangHoa?> capNhatHangHoa(HangHoa hangHoa) async {
    return await hangHoaApiClient.capNhatHangHoa(hangHoa);
  }
}
