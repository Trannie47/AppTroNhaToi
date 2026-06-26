import 'package:AppTroNhaToi/core/network/ChiTietHoaDonTapHoaApiClient.dart';
import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoaPage/chiTietHoaDonTapHoaPage_Model.dart';

class ChiTietTapHoaRepository {
  final ChiTietTapHoaApiClient chiTietTapHoaApiClient =
      ChiTietTapHoaApiClient();

  Future<List<chiTietHoaDonTapHoaPageModel>> getChiTietTheoMaHoaDon(
    String maHoaDon,
  ) async {
    return await chiTietTapHoaApiClient.getChiTietTheoMaHoaDon(maHoaDon);
  }

  Future<ChiTietTapHoa?> themChiTietTapHoa(ChiTietTapHoa chiTiet) async {
    return await chiTietTapHoaApiClient.themChiTietTapHoa(chiTiet);
  }

  Future<bool> xoaChiTietTapHoa(int maChiTietHoaDon) async {
    return await chiTietTapHoaApiClient.xoaChiTietTapHoa(maChiTietHoaDon);
  }

  Future<ChiTietTapHoa?> capNhatChiTietTapHoa(ChiTietTapHoa chiTiet) async {
    return await chiTietTapHoaApiClient.capNhatChiTietTapHoa(chiTiet);
  }
}
