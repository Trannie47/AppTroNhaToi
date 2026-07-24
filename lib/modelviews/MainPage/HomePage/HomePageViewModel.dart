import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/thong_ke_provider.dart';
import 'package:AppTroNhaToi/models/DTO/ThongKeDTO.dart';

import 'package:AppTroNhaToi/models/thong_bao.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThuCongNoForm/thuCongNoFormModel.dart';
import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier {
  final PhongProvider _phongProvider;
  final ThongKeProvider _thongKeProvider;
  final NguoiThueProvider _nguoiThueProvider;

  HomePageViewModel(
    this._phongProvider,
    this._thongKeProvider,
    this._nguoiThueProvider,
  ) {
    _phongProvider.addListener(_onPhongUpdate);
    _thongKeProvider.addListener(_onThongKeUpdate);
    _nguoiThueProvider.addListener(_onNguoiThueUpdate);

    Future.microtask(() async {
      await Future.wait([
        _phongProvider.getListPhong(),
        _thongKeProvider.getThongKe(),
        _nguoiThueProvider.fetchNguoiThueCongNoTapHoa(),
      ]);

      debugPrint(_nguoiThueProvider.hashCode.toString());
    });
  }

  void _onThongKeUpdate() {
    notifyListeners();
  }

  void _onPhongUpdate() {
    notifyListeners();
  }

  void _onNguoiThueUpdate() {
    notifyListeners();
  }

  double get roomCount => _phongProvider.listPhong.length.toDouble();

  double get emptyRoomCount => _phongProvider.listPhongTrong.length.toDouble();

  double get occupiedRoomCount =>
      _phongProvider.listPhongDangThue.length.toDouble();

  ThongKeDTO? get data => _thongKeProvider.thongKe;

  bool get isLoading =>
      _phongProvider.isLoading ||
      _thongKeProvider.isLoading ||
      _nguoiThueProvider.isLoading;
  double get doanhThuThang => data?.doanhThu.tongDoanhThu ?? 0;

  double get congNoThang => data?.congNo.tongCongNo ?? 0;

  List<ThongBao> issues = [
    ThongBao(
      tieuDe: "3 hóa đơn tieuDethu tiền",
      noiDung: "P101 · noiDung202",
      taoLuc: DateTime.now(),
    ),
    ThongBao(
      tieuDe: "2 phòng chưa ghi điện nước",
      noiDung: "P101 · P203",
      taoLuc: DateTime.parse("2026-05-13 18:00:00"),
    ),
    ThongBao(
      tieuDe: "HĐ phòng 203 Hết Hạn",
      noiDung: "Hoàng Văn Bình ",
      taoLuc: DateTime.parse("2026-04-03 18:00:00"),
    ),
  ];

  List<ThuCongNoFormModel> get debts => _nguoiThueProvider.listCongNoTapHoa;

  @override
  void dispose() {
    _thongKeProvider.removeListener(_onThongKeUpdate);
    _phongProvider.removeListener(_onPhongUpdate);
    _nguoiThueProvider.removeListener(_onNguoiThueUpdate);
    super.dispose();
  }
}
