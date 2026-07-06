
import 'package:flutter/material.dart';

import '../../../../models/DTO/HopDongDTO.dart';

class ChiTietHopDongViewModel extends ChangeNotifier {
  late HopDongDTO _hopDong;
  HopDongDTO get hopDong => _hopDong;

  void init(HopDongDTO hd) {
    _hopDong = hd;
    notifyListeners();
  }

}
