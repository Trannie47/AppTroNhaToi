import 'package:AppTroNhaToi/core/network/PhieuThuHoaDonTapHoaApiClient.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';

class PhieuThuHdThRepository {
  final PhieuThuHdThApiClient phieuThuHdThApiClient = PhieuThuHdThApiClient();

  Future<List<PhieuThuHdTh>> getPhieuThuTheoMaHoaDon(String maHoaDon) async {
    return await phieuThuHdThApiClient.getPhieuThuTheoMaHoaDon(maHoaDon);
  }

  Future<PhieuThuHdTh?> themPhieuThuHdTh(PhieuThuHdTh phieuThu) async {
    return await phieuThuHdThApiClient.themPhieuThuHdTh(phieuThu);
  }

  Future<bool> xoaPhieuThuHdTh(int maPhieuThu) async {
    return await phieuThuHdThApiClient.xoaPhieuThuHdTh(maPhieuThu);
  }

  Future<PhieuThuHdTh?> capNhatPhieuThuHdTh(PhieuThuHdTh phieuThu) async {
    return await phieuThuHdThApiClient.capNhatPhieuThuHdTh(phieuThu);
  }
}
