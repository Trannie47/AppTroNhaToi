import 'package:AppTroNhaToi/core/network/ThongBaoApiClient.dart';

import '../models/thong_bao.dart';

class ThongBaoRepository {
  final ThongBaoApiClient thongBaoApiClient = ThongBaoApiClient();

  Future<List<ThongBao>> getAllThongBao() async {
    return await thongBaoApiClient.getAllThongBao();
  }

  Future<List<ThongBao>> getThongBaoChuaDoc() async {
    return await thongBaoApiClient.getThongBaoChuaDoc();
  }

  Future<bool> danhDauDaDoc(int id) async {
    return await thongBaoApiClient.danhDauDaDoc(id);
  }

  Future<bool> danhDauTatCaDaDoc() async {
    return await thongBaoApiClient.danhDauTatCaDaDoc();
  }
}
