// providers/thong_bao_provider.dart
import 'dart:async';
import 'package:AppTroNhaToi/repositories/thongbao_repository.dart';
import 'package:flutter/foundation.dart';

import '../models/thong_bao.dart';

class ThongBaoProvider extends ChangeNotifier {
  final ThongBaoRepository _repo = ThongBaoRepository();

  List<ThongBao> _list = [];
  List<ThongBao> get list => List.unmodifiable(_list);

  int get soLuongChuaDoc {
    return _list.where((e) => e.daDoc != true).length;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Timer? _pollingTimer;

  /// Bắt đầu tự động gọi API mỗi 5 phút
  void startPolling({Duration interval = const Duration(minutes: 5)}) {
    // Gọi ngay 1 lần khi bắt đầu
    fetchAll();

    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) {
      fetchAll();
    });
  }

  /// Dừng polling (gọi khi logout hoặc rời màn hình chính)
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _list = await _repo.getAllThongBao();

      _list.sort((a, b) {
        final aTime = a.taoLuc ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.taoLuc ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
    } catch (e) {
      // Không reset _list = [] để tránh mất dữ liệu cũ khi 1 lần polling lỗi
      if (kDebugMode) {
        print("Lỗi fetchAll ThongBaoProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchChuaDoc() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _list = await _repo.getThongBaoChuaDoc();

      _list.sort((a, b) {
        final aTime = a.taoLuc ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.taoLuc ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi fetchChuaDoc ThongBaoProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> danhDauDaDoc(int id) async {
    final ok = await _repo.danhDauDaDoc(id);

    if (ok) {
      final index = _list.indexWhere((e) => e.id == id);
      if (index != -1) {
        _list[index] = _list[index].copyWith(daDoc: true);
        notifyListeners();
      }
    }

    return ok;
  }

  Future<bool> danhDauTatCaDaDoc() async {
    final ok = await _repo.danhDauTatCaDaDoc();

    if (ok) {
      _list = _list.map((e) => e.copyWith(daDoc: true)).toList();
      notifyListeners();
    }

    return ok;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}