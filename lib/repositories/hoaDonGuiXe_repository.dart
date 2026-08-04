import '../core/network/HoaDonGuiXeApiClient.dart';
import '../models/hoa_don_gui_xe.dart';

class HoaDonGuiXeRepository {
  final _apiClient = HoaDonGuiXeApiClient();

  Future<List<HoaDonGuiXe>> fetchDanhSachHoaDonGuiXe() async {
    try {
      return await _apiClient.getDanhSachHoaDonGuiXe();
    } catch (e) {
      rethrow;
    }
  }
}
