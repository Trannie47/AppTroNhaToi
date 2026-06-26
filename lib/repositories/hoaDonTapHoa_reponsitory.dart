import 'package:AppTroNhaToi/core/network/HoaDonTapHoaApiClient.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';

class HoaDonTapHoaRepository {
  final HoaDonTapHoaApiClient hoaDonTapHoaApiClient = HoaDonTapHoaApiClient();

  Future<List<HoaDonTapHoaModel>> getListHoaDonTapHoa() async {
    final result = await hoaDonTapHoaApiClient.getListHoaDonTapHoa();
    return result;
  }

  Future<HoaDonTapHoa?> themHoaDonTapHoa(HoaDonTapHoa hoaDonTapHoa) async {
    return await hoaDonTapHoaApiClient.themHoaDonTapHoa(hoaDonTapHoa);
  }

  Future<bool> xoaHoaDonTapHoa(String maHoaDon) async {
    return await hoaDonTapHoaApiClient.xoaHoaDonTapHoa(maHoaDon);
  }

  Future<HoaDonTapHoa?> capNhatHoaDonTapHoa(HoaDonTapHoa hoaDonTapHoa) async {
    return await hoaDonTapHoaApiClient.capNhatHoaDonTapHoa(hoaDonTapHoa);
  }
}
