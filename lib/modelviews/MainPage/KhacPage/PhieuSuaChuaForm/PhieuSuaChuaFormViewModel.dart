import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class PhieuSuaChuaViewModel extends ChangeNotifier {

  final txtNgaySuaChua = TextEditingController();

  final txtNguyenNhan = TextEditingController();

  final txtChiPhi = TextEditingController();

  String? errNgaySuaChua;

  String? errNguyenNhan;

  String? errChiPhi;
  bool daSuaXong = false;

  DateTime? chuyenNgay(String ngay) {

    try {

      final tach = ngay.split('/');

      return DateTime(
        int.parse(tach[2]),
        int.parse(tach[1]),
        int.parse(tach[0]),
      );
    }
    catch (_) {

      return null;
    }
  }

  Future<void> chonNgay(
      BuildContext context,
      TextEditingController controller,
      ) async {

    DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (ngay != null) {

      controller.text = formatDate(ngay);

      notifyListeners();
    }
  }

  bool kiemTraDuLieu() {

    errNgaySuaChua = null;
    errNguyenNhan = null;
    errChiPhi = null;

    bool hopLe = true;

    errNgaySuaChua = kiemTraNgay(
      txtNgaySuaChua.text,
      minYear: 2000,
    );

    if (errNgaySuaChua != null) {

      hopLe = false;
    }

    else {

      DateTime? ngaySua =
      chuyenNgay(txtNgaySuaChua.text);

      if (ngaySua != null &&
          ngaySua.isAfter(DateTime.now())) {

        errNgaySuaChua =
        "Ngày sửa chữa không được lớn hơn ngày hiện tại";

        hopLe = false;
      }
    }

    if (txtNguyenNhan.text.trim().isEmpty) {

      errNguyenNhan =
      "Vui lòng nhập nguyên nhân / triệu chứng";

      hopLe = false;
    }

    else if (txtNguyenNhan.text
        .trim()
        .length < 5) {

      errNguyenNhan =
      "Nguyên nhân phải có ít nhất 5 ký tự";

      hopLe = false;
    }

    if (daSuaXong) {

      if (txtChiPhi.text.trim().isEmpty) {

        errChiPhi =
        "Vui lòng nhập chi phí sửa chữa";

        hopLe = false;
      }
    }

    if (txtChiPhi.text.trim().isNotEmpty) {

      double? chiPhi =
      double.tryParse(txtChiPhi.text);

      if (chiPhi == null) {

        errChiPhi =
        "Chi phí chỉ được nhập số";

        hopLe = false;
      }

      else if (chiPhi < 0) {

        errChiPhi =
        "Chi phí phải lớn hơn hoặc bằng 0";

        hopLe = false;
      }
    }

    notifyListeners();

    return hopLe;
  }

  @override
  void dispose() {

    txtNgaySuaChua.dispose();

    txtNguyenNhan.dispose();

    txtChiPhi.dispose();

    super.dispose();
  }

  void doiTrangThaiSuaXong(bool value) {

    daSuaXong = value;

    if (!daSuaXong) {

      errChiPhi = null;
    }

    notifyListeners();
  }
}