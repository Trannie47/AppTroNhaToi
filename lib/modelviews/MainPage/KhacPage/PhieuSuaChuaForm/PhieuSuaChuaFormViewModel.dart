import 'package:AppTroNhaToi/Provider/lap_rap_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart' as DateFormate;
import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:flutter/material.dart';

class PhieuSuaChuaViewModel extends ChangeNotifier {
  final txtNgaySuaChua = TextEditingController();

  final txtNguyenNhan = TextEditingController();

  final txtChiPhi = TextEditingController();
  int sttHoaDon = 1;
  bool taoHoaDon = false;
  bool daTaoHoaDon = false;
  final txtNgayHoaDon = TextEditingController();
  final txtGhiChu = TextEditingController();
  String maHoaDon = "";
  int? maSuaChua;
  String? errNgayHoaDon;
  String? errNgaySuaChua;
  String? errNguyenNhan;
  String? errChiPhi;
  String? errPhong;
  String? errGhiChu;
  int? loaiSua = 0;
  int? trangThai = 0;

  /// Mức độ xử lý sự cố: 0 = Bình thường, 1 = Gấp (còn ≤ 7 ngày phải xử lý)
  int trangThaiThongBao = 0;

  /// ID phòng đang được chọn ở dropdown "Phòng lắp đặt"
  int? phongDaChonId;

  int? lapRapDaChonId;

  LapRap? lapRapCoDinh;
  bool get lapDatBiKhoa => lapRapCoDinh != null;

  ItemPhong? phongCoDinh;
  bool isLoadingPhongCoDinh = false;

  ItemPhong? phongDaLuu;

  /// Đang tải lại phòng/lắp đặt cũ khi mở form SỬA mà không có LapRap cố định
  bool isLoadingDuLieuCu = false;

  late ThietBi thietBi;
  final PhongProvider _phongProvider;
  final SuaChuaProvider _suaChuaProvider;
  final LapRapProvider _lapRapProvider;

  List<ItemPhong> get dsPhong => _phongProvider.listPhongByThietBi;
  bool get isLoadingPhong => _phongProvider.isLoading;

  List<LapRapPageModel> get dsLapRapTheoPhong => _lapRapProvider.listLapRapPage;

  bool get coThePhongLapDat => phongDaChonId != null;

  PhieuSuaChuaViewModel({
    required PhongProvider phongProvider,
    required SuaChuaProvider suaChuaProvider,
    required LapRapProvider lapRapProvider,
  }) : _phongProvider = phongProvider,
       _suaChuaProvider = suaChuaProvider,
       _lapRapProvider = lapRapProvider {
    _phongProvider.addListener(_onProviderUpdate);
    _lapRapProvider.addListener(_onProviderUpdate);
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  SuaChua? suaChua;
  HoaDonSuaChua? hoaDonSuaChua;
  DateTime ngaySua = DateTime.now();
  DateTime ngayLapHoaDon = DateTime.now();

  final Map<int, String> dsLoaiSua = {
    0: "Sửa chữa nhỏ",
    1: "Sửa chữa lớn",
    2: "Bảo trì định kỳ",
    3: "Thay thế linh kiện",
    4: "Vệ sinh thiết bị",
    5: "Khắc phục sự cố điện",
    6: "Khắc phục sự cố nước",
    7: "Sửa chữa khẩn cấp",
    8: "Nâng cấp thiết bị",
    9: "Khác",
  };

  final Map<int, String> dsTrangThai = {
    0: "Đang sửa chữa",
    1: "Đã hoàn thành",
    2: "Đã thanh toán",
    3: "Đã hủy",
  };

  Future<void> chonNgay(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final now = DateTime.now();

    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDayOfMonth,
      lastDate: lastDayOfMonth,
    );

    if (ngay != null) {
      controller.text = formatDate(ngay);
      notifyListeners();
    }
  }

  /// Chọn phòng lắp đặt -> load lại danh sách lắp ráp theo phòng + thiết bị,
  /// và reset lựa chọn "Lắp đặt" cũ (vì đổi phòng thì lắp đặt cũ không còn hợp lệ).
  Future<void> chonPhong(int? phongId) async {
    phongDaChonId = phongId;
    lapRapDaChonId = null;
    errPhong = null;
    notifyListeners();

    if (phongId != null && thietBi.thietBiID != null) {
      await _lapRapProvider.findByPhongVaThietBi(
        phongId: phongId,
        thietBiId: thietBi.thietBiID!,
      );
    }
  }

  void chonLapRap(int? lapRapId) {
    lapRapDaChonId = lapRapId;
    errPhong = null;
    notifyListeners();
  }

  void setLoaiSua(int value) {
    loaiSua = value;

    notifyListeners();
  }

  void setTrangThai(int value) {
    trangThai = value;

    notifyListeners();
  }

  void setTrangThaiThongBao(int value) {
    trangThaiThongBao = value;

    notifyListeners();
  }

  bool kiemTraDuLieu() {
    bool hopLe = true;

    errNgaySuaChua = null;
    errNguyenNhan = null;
    errChiPhi = null;
    errNgayHoaDon = null;
    errPhong = null;
    errGhiChu = null;

    if (phongDaChonId == null) {
      errPhong = "Vui lòng chọn phòng";
      hopLe = false;
    } else if (lapRapDaChonId == null) {
      errPhong = "Vui lòng chọn lắp đặt";
      hopLe = false;
    }

    if (taoHoaDon) {
      DateTime? ngaySua = chuyenNgay(txtNgaySuaChua.text);

      DateTime? ngayHoaDon = chuyenNgay(txtNgayHoaDon.text);

      if (ngaySua != null &&
          ngayHoaDon != null &&
          ngaySua.isAfter(ngayHoaDon)) {
        errNgayHoaDon = "Ngày lập hóa đơn phải lớn hơn hoặc bằng ngày sửa chữa";

        hopLe = false;
      }

      errNgayHoaDon = kiemTraNgay(txtNgayHoaDon.text, minYear: 2000);

      if (errNgayHoaDon != null) {
        hopLe = false;
      }

      if (loaiSua == null) {
        hopLe = false;
      }

      if (trangThai == null) {
        hopLe = false;
      }
      errNgaySuaChua = kiemTraNgay(txtNgaySuaChua.text, minYear: 2000);
    }

    if (errNgaySuaChua != null) {
      hopLe = false;
    } else {
      DateTime? ngaySua = chuyenNgay(txtNgaySuaChua.text);

      if (ngaySua != null && ngaySua.isAfter(DateTime.now())) {
        errNgaySuaChua = "Ngày sửa chữa không được lớn hơn ngày hiện tại";

        hopLe = false;
      }
    }

    if (txtNguyenNhan.text.trim().isEmpty) {
      errNguyenNhan = "Vui lòng nhập nguyên nhân / triệu chứng";

      hopLe = false;
    } else if (txtNguyenNhan.text.trim().length < 5) {
      errNguyenNhan = "Nguyên nhân phải có ít nhất 5 ký tự";

      hopLe = false;
    }

    if (taoHoaDon) {
      if (txtChiPhi.text.replaceAll('.', '').trim().isEmpty) {
        errChiPhi = "Vui lòng nhập chi phí sửa chữa";

        hopLe = false;
      }
    }

    // Chi phí có thể bằng 0 (ví dụ sửa miễn phí/bảo hành) nhưng không được âm.
    if (txtChiPhi.text.trim().isNotEmpty) {
      int? chiPhi = int.tryParse(txtChiPhi.text.replaceAll('.', '').trim());

      if (chiPhi == null) {
        errChiPhi = "Chi phí chỉ được nhập số nguyên";

        hopLe = false;
      } else if (chiPhi < 0) {
        errChiPhi = "Chi phí không được là số âm";

        hopLe = false;
      }
    }

    notifyListeners();

    return hopLe;
  }

  void init(
    ThietBi thietBiData, {
    SuaChua? suaChuaData,
    HoaDonSuaChua? hoaDonData,
    LapRap? lapRapCoDinhData,
  }) {
    thietBi = thietBiData;

    suaChua = suaChuaData;
    hoaDonSuaChua = hoaDonData;
    lapRapCoDinh = lapRapCoDinhData;

    if (lapRapCoDinh != null) {
      // Gán cứng luôn, không cho chọn lại
      phongDaChonId = lapRapCoDinh!.phongID;

      lapRapDaChonId = lapRapCoDinh!.id;
    } else {
      lapRapDaChonId = suaChua?.lapRapID;
    }

    if (suaChua == null) {
      txtNgaySuaChua.text = formatDate(DateTime.now());
      ngaySua = DateTime.now();
      txtNgayHoaDon.text = txtNgaySuaChua.text;
      ngayLapHoaDon = ngaySua;
    } else {
      maSuaChua = suaChua!.id;
      ngaySua = suaChua!.ngaySuaChua!;
      txtNgaySuaChua.text = formatDate(ngaySua);
      txtNguyenNhan.text = suaChua!.nguyenNhan ?? "";
      trangThaiThongBao = suaChua!.trangThaiThongBao ?? 0;
    }

    if (hoaDonSuaChua != null) {
      taoHoaDon = true;
      daTaoHoaDon = true;
      maHoaDon = hoaDonSuaChua!.maHoaDonSC?.toString() ?? "";
      ngayLapHoaDon = hoaDonSuaChua!.ngayLapHoaDonSC!;
      txtNgayHoaDon.text = formatDate(hoaDonSuaChua!.ngayLapHoaDonSC);
      txtChiPhi.text = (hoaDonSuaChua!.giaTien ?? 0).toInt().toString();
      loaiSua = hoaDonSuaChua!.loaiSua ?? 0;
      trangThai = hoaDonSuaChua!.trangThai ?? 0;
      txtGhiChu.text = hoaDonSuaChua!.ghiChu ?? "";
    }

    Future.microtask(() async {
      await _phongProvider.getListByThietBi(thietBiData.thietBiID!);

      if (lapRapCoDinh != null && phongDaChonId != null) {
        // Nếu phòng bị khóa cứng (đến từ 1 LapRap cụ thể) -> lấy đúng thông tin
        // phòng thật từ provider, thay vì tạo object giả với dữ liệu mặc định.
        isLoadingPhongCoDinh = true;
        notifyListeners();

        try {
          phongCoDinh = await _phongProvider.getInforPhong(phongDaChonId!);
        } catch (_) {
          phongCoDinh = null;
        } finally {
          isLoadingPhongCoDinh = false;
          notifyListeners();
        }
      } else if (suaChua != null && suaChua!.lapRapID != null) {
        // Đang SỬA 1 sự cố có sẵn nhưng KHÔNG mở kèm LapRap cố định
        // -> cần tự tìm phòng của bản ghi lắp ráp đã gắn, để 2 dropdown
        // (Phòng lắp đặt / Lắp đặt) hiện đúng dữ liệu cũ, không bị trống.
        isLoadingDuLieuCu = true;
        notifyListeners();

        try {
          final lapRapDaGan = await _lapRapProvider.getById(suaChua!.lapRapID!);

          if (lapRapDaGan?.phongID != null) {
            phongDaChonId = lapRapDaGan!.phongID;
            notifyListeners();

            // Lấy thông tin phòng trực tiếp từ lắp đặt, không phụ thuộc
            // dsPhong (dsPhong có thể không chứa phòng này nếu đã hết chỗ trống).
            try {
              phongDaLuu = await _phongProvider.getInforPhong(phongDaChonId!);
            } catch (_) {
              phongDaLuu = null;
            }

            await _lapRapProvider.findByPhongVaThietBi(
              phongId: phongDaChonId!,
              thietBiId: thietBi.thietBiID!,
            );
          }
        } catch (_) {
          // Không tìm được dữ liệu cũ -> giữ nguyên dropdown trống,
          // không làm crash màn hình.
        } finally {
          isLoadingDuLieuCu = false;
          notifyListeners();
        }
      }
    });
  }

  Future<SuaChuaDTO?> luu() async {
    if (!kiemTraDuLieu()) return null;

    final dto = SuaChuaDTO(
      id: maSuaChua,
      lapRapId: lapRapDaChonId,
      thietBiId: thietBi.thietBiID,
      nguyenNhan: txtNguyenNhan.text.trim(),
      ngaySuaChua: DateFormate.chuyenNgay(txtNgaySuaChua.text)!,
      trangThaiThongBao: trangThaiThongBao,
      hoaDonSuaChua: taoHoaDon
          ? HoaDonSuaChua(
              maHoaDonSC: daTaoHoaDon ? maHoaDon : null,
              trangThai: trangThai,
              giaTien: double.tryParse(
                txtChiPhi.text.replaceAll('.', '').trim(),
              ),
              loaiSua: loaiSua,
              ngayLapHoaDonSC: DateFormate.chuyenNgay(txtNgayHoaDon.text),
              ghiChu: txtGhiChu.text.trim(),
            )
          : null,
    );

    if (maSuaChua == null) {
      return await _suaChuaProvider.them(dto);
    } else {
      return await _suaChuaProvider.capNhat(dto);
    }
  }

  @override
  void dispose() {
    _phongProvider.removeListener(_onProviderUpdate);
    _lapRapProvider.removeListener(_onProviderUpdate);

    txtNgaySuaChua.dispose();
    txtNguyenNhan.dispose();
    txtChiPhi.dispose();
    txtNgayHoaDon.dispose();
    txtGhiChu.dispose();

    super.dispose();
  }

  void doiTrangThaiTaoHoaDon(bool value) {
    if (daTaoHoaDon && value == false) {
      return;
    }

    taoHoaDon = value;

    if (!taoHoaDon) {
      errChiPhi = null;

      errNgayHoaDon = null;
    }

    notifyListeners();
  }
}
