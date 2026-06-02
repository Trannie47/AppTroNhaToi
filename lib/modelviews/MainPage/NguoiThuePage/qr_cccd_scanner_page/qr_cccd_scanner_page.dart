import 'package:flutter/material.dart';

class QRCCCDScannerPageViewModel
    extends ChangeNotifier {

  bool scanned = false;

  bool allowScan() {
    if (scanned) {
      return false;
    }

    scanned = true;
    notifyListeners();

    return true;
  }

  void reset() {
    scanned = false;
    notifyListeners();
  }
}