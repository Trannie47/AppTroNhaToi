import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue_phong.dart';
import 'package:flutter/material.dart';

import '../../../Provider/nguoi_thue_provider.dart';

class NguoiThuePageViewModel extends ChangeNotifier {
  final NguoiThueProvider _service;
  final TextEditingController searchController = TextEditingController();
  List<NguoiThue> get listNguoiThue => _service.list;
  bool get isLoading => _service.isLoading;

  NguoiThuePageViewModel(this._service){
    _service.addListener(_onProviderUpdate);
  }

  Future<void> refresh() => _service.fetchAll();

  @override
  void dispose() {
    _service.removeListener(_onProviderUpdate);
    searchController.dispose();
    super.dispose();
  }
  void _onProviderUpdate() {
    notifyListeners();
  }
}
