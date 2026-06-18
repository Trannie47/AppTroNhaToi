import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDongViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDong_Model.dart';
import 'package:flutter/material.dart';

// ===================== VIEW MODEL =====================

class ChiTietPhongViewModel extends ChangeNotifier {
  final Phong phong;
  final LoaiPhong loaiphong;

  ChiTietPhongViewModel({required this.phong, required this.loaiphong}) {
    _loadData();
  }

  // ---- State ----
  bool _isLoading = false;
  String? _errorMessage;
  Phong? _phong;
  List<chiTietHopDongModel> _dsChiTietHopDong = [];
  int _selectedTabIndex = 0;

  // ---- Getters ----
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<chiTietHopDongModel> get danhSachNguoiThue => _dsChiTietHopDong;
  int get selectedTabIndex => _selectedTabIndex;

  bool get dangChoThue => _phong?.trangThai == 'dang_cho_thue';

  String get trangThaiText {
    return _phong!.trangThaiText;
  }

  Color get trangThaiColor {
    switch (_phong?.trangThai) {
      case 'dang_cho_thue':
        return const Color(0xFFF59E0B);
      case 'trong':
        return const Color(0xFF22C55E);
      case 'bao_tri':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  // ---- Methods ----
  void selectTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  Future<void> _loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      _dsChiTietHopDong = [];
    } catch (e) {
      _errorMessage = 'Không thể tải dữ liệu phòng. Vui lòng thử lại.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => _loadData();

  @override
  void dispose() {
    // No controllers or streams to dispose currently.
    // Keep this override for future cleanup.
    super.dispose();
  }
}
