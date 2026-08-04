import 'package:AppTroNhaToi/core/network/PhuongTienApiClient.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';

class PhuongTienRepository {
  final PhuongTienApiClient _apiClient = PhuongTienApiClient();

  Future<List<PhuongTien>> getDsPhuongTienByNguoiThue(int idnt) async {
    return await _apiClient.getDsPhuongTienByNguoiThue(idnt);
  }

  Future<PhuongTien> createPhuongTien(PhuongTien xe) async {
    return await _apiClient.createPhuongTien(xe);
  }

  Future<PhuongTien> updatePhuongTien(num id, PhuongTien xe) async {
    return await _apiClient.updatePhuongTien(id, xe);
  }

  Future<PhuongTien> deletePhuongTien(num id) async {
    return await _apiClient.deletePhuongTien(id);
  }
}
