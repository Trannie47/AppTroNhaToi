import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../Provider/hop_dong_provider.dart';
import '../../../../models/DTO/HopDongDTO.dart';
import '../../../../models/DTO/NguoiOGhepDTO.dart';
import '../../../../models/hop_dong.dart';
import '../../../../models/item_phong.dart';

class ChiTietHopDongViewModel extends ChangeNotifier {
  final PhongProvider _phongProvider;
  final HopDongProvider _hopDongProvider;
  ChiTietHopDongViewModel(this._phongProvider, this._hopDongProvider);

  late HopDongDTO _hopDong;
  HopDongDTO get hopDong => _hopDong;

  bool _isLoadingPhong = false;
  bool get isLoadingPhong => _isLoadingPhong;
  bool isUpdated = false;

  void init(HopDongDTO hd) {
    _hopDong = hd;
    notifyListeners();
  }

  //lấy thông tin itemPhong để hieenr thij thông tin chi tiết phòng
  Future<ItemPhongModel?> getInforPhong(int phongId) async {
    //Tìm trong list đã có sẵn
    final phongTrongList = _phongProvider.listPhong
        .where((p) => p.phongId == phongId)
        .firstOrNull;

    if (phongTrongList != null) return phongTrongList;

    //Không có → gọi API
    _isLoadingPhong = true;
    notifyListeners();
    try {
      return await _phongProvider.getInforPhong(phongId);
    } catch (e) {
      if (kDebugMode) print("Lỗi getInforPhong: $e");
      return null;
    } finally {
      _isLoadingPhong = false;
      notifyListeners();
    }
  }

  Future<bool> deleteHopDong(String hopDongId) async {
    try {
      _isLoadingPhong = true;
      notifyListeners();

      final success = await _hopDongProvider.deleteHopDong(hopDongId);
      if (success) {
        isUpdated = true;
      }
      return success;
    } catch (e) {
      if (kDebugMode) print("Lỗi ẩn hợp đồng trong VM: $e");
      return false;
    } finally {
      _isLoadingPhong = false;
      notifyListeners();
    }
  }

  Future<bool> cancelHopDong(String hopDongId) async {
    try {
      _isLoadingPhong = true;
      notifyListeners();

      final success = await _hopDongProvider.cancelHopDong(hopDongId);
      if (success) {
        isUpdated = true;
      }
      return success;
    } catch (e) {
      if (kDebugMode) print("Lỗi hủy hợp đồng trong VM: $e");
      rethrow;
    } finally {
      _isLoadingPhong = false;
      notifyListeners();
    }
  }

  Future<bool> terminateHopDong(String hopDongId) async {
    try {
      _isLoadingPhong = true;
      notifyListeners();

      final success = await _hopDongProvider.terminateHopDong(hopDongId);
      if (success) {
        isUpdated = true;
      }
      return success;
    } catch (e) {
      if (kDebugMode) print("Lỗi kết thúc hợp đồng trong VM: $e");
      rethrow; // Ném tiếp lỗi ra ngoài để UI bắt được nội dung thông báo
    } finally {
      _isLoadingPhong = false;
      notifyListeners();
    }
  }

  void updateHopDongData(HopDong hd, List<NguoiOGhepDTO> nguoiOGhep) {
    _hopDong = HopDongDTO(
      hopDongID: hd.hopDongID ?? _hopDong.hopDongID,
      phongID: hd.phongID ?? _hopDong.phongID,
      ngayKy: hd.ngayKy ?? _hopDong.ngayKy,
      ngayHetHan: hd.ngayHetHan ?? _hopDong.ngayHetHan,
      tienCoc: hd.tienCoc ?? _hopDong.tienCoc,
      giaPhongThucTe: hd.giaPhongThucTe ?? _hopDong.giaPhongThucTe,
      ghiChu: hd.ghiChu,
      dsAnhHopDong: (hd.dsAnhHopDong != null && hd.dsAnhHopDong!.isNotEmpty)
          ? hd.dsAnhHopDong!
          : _hopDong.dsAnhHopDong,
      trangThai: hd.trangThai ?? _hopDong.trangThai,
      phong: _hopDong.phong,
      idntDaiDien: _hopDong.idntDaiDien,
      nguoiDaiDien: _hopDong.nguoiDaiDien,
      nguoiOGhep: nguoiOGhep,
    );
    isUpdated = true;
    notifyListeners();
  }
}
