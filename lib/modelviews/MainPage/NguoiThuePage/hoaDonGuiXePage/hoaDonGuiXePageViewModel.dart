import 'package:flutter/foundation.dart';
import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import '../../../../Provider/hoa_don_gui_xe_provider.dart';

class HoaDonGuiXePageViewModel extends ChangeNotifier {
  final List<PhuongTien> dsPhuongTien;
  final HoaDonGuiXeProvider provider;
  final String tenKhachThue;

  HoaDonGuiXePageViewModel({
    required this.dsPhuongTien,
    required this.provider,
    required this.tenKhachThue,
  }) {
    provider.addListener(_onProviderChanged);
    provider.loadDanhSachHoaDon();
  }

  void _onProviderChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    provider.removeListener(_onProviderChanged);
    super.dispose();
  }

  String namDangChon = DateTime.now().year.toString();

  void changeYear(String value) {
    namDangChon = value;
    notifyListeners();
  }

  // Lấy danh sách ID các phương tiện của người thuê này
  List<num> get _idsPhuongTien {
    return dsPhuongTien.map((e) => e.ID ?? -1).toList();
  }

  // CHỈ LẤY HÓA ĐƠN THUỘC VỀ CÁC XE CỦA NGƯỜI THUÊ NÀY
  List<HoaDonGuiXe> get danhSachHoaDonCuaKhach {
    final ids = _idsPhuongTien;
    return provider.danhSachHoaDon.where((hd) {
      return ids.contains(hd.idPhuongTien);
    }).toList();
  }

  bool get isLoading => provider.isLoading;
  String? get errorMessage => provider.errorMessage;

  List<String> get dsNam {
    Set<String> setNam = {};
    for (var hd in danhSachHoaDonCuaKhach) {
      if (hd.thangNam != null) {
        final parts = hd.thangNam!.split('/');
        if (parts.length > 1) {
          setNam.add(parts.last.trim());
        } else if (hd.thangNam!.length >= 4) {
          setNam.add(hd.thangNam!.substring(hd.thangNam!.length - 4));
        }
      }
    }
    if (setNam.isEmpty) {
      setNam.add(DateTime.now().year.toString());
    }
    List<String> sortedList = setNam.toList();
    sortedList.sort((a, b) => b.compareTo(a));
    return sortedList;
  }

  List<HoaDonGuiXe> get dsHoaDonTheoNam {
    return danhSachHoaDonCuaKhach.where((e) {
      if (e.thangNam == null) return false;
      return e.thangNam!.contains(namDangChon);
    }).toList();
  }

  int get tongSoXe => dsPhuongTien.length;

  // Tổng tiền xe hàng tháng (dựa trên giá gửi thực tế của các xe)
  double get tongTienThang {
    double tong = 0;
    for (final xe in dsPhuongTien) {
      tong += xe.giaGui ?? 0;
    }
    return tong;
  }

  // Danh sách hóa đơn chưa thu (trangThai == 0) của khách này
  List<HoaDonGuiXe> get dsHoaDonNo {
    return danhSachHoaDonCuaKhach.where((e) => e.trangThai == 0).toList();
  }

  PhuongTien? getXeTheoHoaDon(HoaDonGuiXe hoaDon) {
    final dsXeTimDuoc = dsPhuongTien.where(
          (e) => e.ID == hoaDon.idPhuongTien,
    ).toList();
    if (dsXeTimDuoc.isEmpty) return null;
    return dsXeTimDuoc.first;
  }

  double get tongTienNo {
    double tong = 0;
    for (final hoaDon in dsHoaDonNo) {
      // Ưu tiên lấy soTien trực tiếp từ hóa đơn, nếu không có mới lấy giá gửi của xe
      final xe = getXeTheoHoaDon(hoaDon);
      final tien = hoaDon.soTien ?? xe?.giaGui ?? 0;
      tong += tien.toDouble();
    }
    return tong;
  }

  String get textNo {
    if (dsHoaDonNo.isEmpty) {
      return "Không có nợ";
    }
    final hoaDonMoiNhat = dsHoaDonNo.first;
    return "${tongTienNo.toStringAsFixed(0)}đ • ${hoaDonMoiNhat.thangNam ?? ''}";
  }
}