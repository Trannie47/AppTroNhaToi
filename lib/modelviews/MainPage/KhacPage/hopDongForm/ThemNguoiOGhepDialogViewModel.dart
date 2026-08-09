import 'package:flutter/material.dart';

import 'HopDongFormViewModel.dart';

class ThemNguoiOGhepDialogViewModel extends ChangeNotifier {
  final HopDongFormViewModel formViewModel;

  final cccdController = TextEditingController();
  final hoTenController = TextEditingController();
  final sdtController = TextEditingController();
  final quanHeController = TextEditingController();


  String? errCccd;
  String? errHoTen;
  String? errSdt;
  String? errQuanHe;

  ThemNguoiOGhepDialogViewModel({required this.formViewModel}) {
    cccdController.addListener(() {
      if (errCccd != null) {
        errCccd = null;
        notifyListeners();
      }
    });
    hoTenController.addListener(() {
      if (errHoTen != null) {
        errHoTen = null;
        notifyListeners();
      }
    });
    sdtController.addListener(() {
      if (errSdt != null) {
        errSdt = null;
        notifyListeners();
      }
    });
    quanHeController.addListener(() {
      if (errQuanHe != null) {
        errQuanHe = null;
        notifyListeners();
      }
    });
  }

  bool submit() {
    final loi = formViewModel.addNguoiOGhep(
      cccd: cccdController.text,
      hoTen: hoTenController.text,
      sdt: sdtController.text,
      quanHeVoiDaiDien: quanHeController.text,
    );


    errCccd = loi['cccd'];
    errHoTen = loi['hoTen'];
    errSdt = loi['sdt'];
    errQuanHe = loi['quanHe'];
    notifyListeners();

    return loi.isEmpty;
  }

  @override
  void dispose() {
    cccdController.dispose();
    hoTenController.dispose();
    sdtController.dispose();
    quanHeController.dispose();
    super.dispose();
  }
}
