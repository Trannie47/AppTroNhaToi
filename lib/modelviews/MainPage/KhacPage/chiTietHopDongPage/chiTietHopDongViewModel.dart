import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDong_Model.dart';
import 'package:flutter/material.dart';

class ChiTietHopDongViewModel extends ChangeNotifier {
  late HopDong hopDong;

  List<HopDong> danhSachHopDong = [];

  List<NguoiThue> danhSachThanhVien = [];

  List<chiTietHopDongModel> danhSachChungPhong = [];

  void init(HopDong hd) {
    hopDong = hd;

    _loadFakeData();

    danhSachChungPhong = getDanhSachChungPhong();

    notifyListeners();
  }

  void _loadFakeData() {
    danhSachHopDong = [
      HopDong(
        hopDongID: 'HD-101-AN-01',
        ngayKy: DateTime(2023, 1, 1),
        ngayHetHan: DateTime(2023, 12, 31),
        giaPhongThucTe: 5000000,
        tienCoc: 5000000,
        trangThai: 1,
        idnt: 3,
        phongID: 101,
      ),
      HopDong(
        hopDongID: 'HD-102-BN-01',
        ngayKy: DateTime(2023, 2, 1),
        ngayHetHan: DateTime(2023, 11, 30),
        giaPhongThucTe: 4500000,
        tienCoc: 4500000,
        trangThai: 1,
        idnt: 4,
        phongID: 2,
      ),
      HopDong(
        hopDongID: 'HD-103-CN-01',
        ngayKy: DateTime(2023, 3, 1),
        ngayHetHan: DateTime(2023, 10, 31),
        giaPhongThucTe: 4000000,
        tienCoc: 4000000,
        trangThai: 1,
        idnt: 5,
        phongID: 101,
      ),
    ];

    danhSachThanhVien = [
      NguoiThue(
        idnt: 3,
        cccd: "123456789012",
        hoTen: "Nguyễn Văn An",
        ngaySinh: DateTime(1995, 5, 20),
        sdt: "0123456789",
        queQuan: "Hà Nội",
        ghiChu: "Thành viên chính trong hợp đồng.",
        gioiTinh: true,
      ),
      NguoiThue(
        idnt: 4,
        cccd: "987654321012",
        hoTen: "Trần Thị Bình",
        ngaySinh: DateTime(1996, 8, 15),
        sdt: "0987654321",
        queQuan: "Hồ Chí Minh",
        ghiChu: "Thành viên phụ trong hợp đồng.",
        gioiTinh: false,
      ),
      NguoiThue(
        idnt: 5,
        cccd: "456789012345",
        hoTen: "Lê Văn Cường",
        ngaySinh: DateTime(1994, 12, 10),
        sdt: "0112233445",
        queQuan: "Đà Nẵng",
        ghiChu: "Thành viên phụ trong hợp đồng.",
        gioiTinh: true,
      ),
    ];
  }

  List<chiTietHopDongModel> getDanhSachChungPhong() {
    List<chiTietHopDongModel> ds = [];

    for (var hd in danhSachHopDong) {
      if (hd.phongID == hopDong.phongID) {
        NguoiThue nt = danhSachThanhVien.firstWhere(
          (e) => e.idnt == hd.idnt,
          orElse: () => NguoiThue(
            idnt: 0,
            cccd: "",
            hoTen: "Không xác định",
            ngaySinh: DateTime(2000, 1, 1),
            sdt: "",
            queQuan: "",
            ghiChu: "",
            gioiTinh: true,
          ),
        );

        ds.add(chiTietHopDongModel(hopDong: hd, nguoiThue: nt));
      }
    }

    return ds;
  }

  @override
  void dispose() {
    // txtHoTen.dispose();
    // txtCCCD.dispose();
    // scrollController.dispose();
    // timer?.cancel();
    // streamSubscription?.cancel();

    super.dispose();
  }
}
