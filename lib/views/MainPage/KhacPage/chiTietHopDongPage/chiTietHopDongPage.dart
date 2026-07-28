import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDongViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHopDongPage/xemAnhHopDong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/hop_dong.dart';
import '../../../../widgets/app_confirm_dialog.dart';
import '../../PhongPage/ChiTietPhongPage/phongChiTiet.dart';
import '../HopDongForm/hopDongForm.dart';
import '../giaHanHopDongPage/giaHanHopDongPage.dart';

class ChiTietHopDongPage extends StatefulWidget {
  final HopDongDTO hopDong;
  const ChiTietHopDongPage({super.key, required this.hopDong});

  @override
  State<ChiTietHopDongPage> createState() => _ChiTietHopDongPageState();
}

class _ChiTietHopDongPageState extends State<ChiTietHopDongPage> {
  late ChiTietHopDongViewModel vm;


  @override
  void initState() {

     super.initState();
     vm = ChiTietHopDongViewModel(context.read<PhongProvider>(), context.read<HopDongProvider>());
     vm.init(widget.hopDong);
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem hợp đồng đã kết thúc chưa
    final bool isDaKetThuc = vm.hopDong.trangThai == 2;
    return
      Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xffF3F3F3),
                borderRadius: BorderRadius.circular(36),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context,vm.isUpdated),
              ),
            ),
          ),
        ),

        titleSpacing: 16,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chi tiết hợp đồng",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff111111),
              ),
            ),
            Text(
              vm.hopDong.hopDongID,
              style: TextStyle(fontSize: 14, color: Color(0xff888888)),
            ),
          ],
        ),
      //Menu
        actions: [
          if (!isDaKetThuc)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _menu(context, vm),
            ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _tenantInfo(vm.hopDong),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _thongTinThuePhong(vm.hopDong),
                  const SizedBox(height: 16),
                  _anhHopDong(context, vm.hopDong.dsAnhHopDong),
                  const SizedBox(height: 16),

                ],
              ),
            ),
          ],
        ),
      ),

        bottomNavigationBar:Container(
          color: const Color(0xffF3F3F3),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (vm.hopDong.trangThai != 2) ...[
                _chiTietPhongButton(context, vm),
                const SizedBox(height: 16),
              ],
              _actionHopDongButton(
                title: vm.hopDong.trangThai == 0
                    ? "Hủy hợp đồng"
                    : vm.hopDong.trangThai == 1
                    ? "Kết thúc hợp đồng"
                    : "Ẩn hợp đồng",
                onPressed: () {
                  if (vm.hopDong.trangThai == 0) {
                    _handleCancelContract();
                  } else if (vm.hopDong.trangThai == 1) {
                    _handleTerminateContract();
                  }else{
                    _handleDeleteContract();
                  }
                },
              ),
            ],
          ),
        ),
    );
  }
  void _handleCancelContract() {
    showDialog(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: "Xác nhận hủy hợp đồng",
        content: "Bạn có chắc chắn muốn hủy hợp đồng chờ hiệu lực này không?",
        textConfirm: "Xác nhận",
        isDangerous: true,
        onConfirm: () async {
          Navigator.pop(dialogContext);

          try {
            bool success = await vm.cancelHopDong(vm.hopDong.hopDongID);

            if (success && mounted) {
              await context.read<PhongProvider>().getListPhong();
              await context.read<NguoiThueProvider>().fetchAll();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Hủy hợp đồng thành công!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context, true);
              }
            }
          } catch (e) {
            if (mounted) {
              String errorMsg = "Không thể hủy hợp đồng do còn vướng công nợ!";

              final err = e as dynamic;
              if (err.response != null && err.response?.data != null) {
                final responseData = err.response?.data;
                if (responseData is Map && responseData['message'] != null) {
                  final message = responseData['message'];
                  if (message is List) {
                    errorMsg = message.join('\n');
                  } else {
                    errorMsg = message.toString();
                  }
                }
              } else {
                errorMsg = e.toString().replaceAll("Exception: ", "");
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    errorMsg,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _handleDeleteContract() {
    showDialog(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: "Xác nhận ẩn hợp đồng",
        content: "Bạn có chắc chắn muốn ẩn hợp đồng này không?",
        textConfirm: "Ẩn hợp đồng",
        isDangerous: true,
        onConfirm: () async {
          bool success = await vm.deleteHopDong(vm.hopDong.hopDongID);
          if (context.mounted) {
            Navigator.pop(context, success ? true : false);
          }
        },
      ),
    ).then((result) async {
      if (result == true && context.mounted) {
        await context.read<PhongProvider>().getListPhong();
        await context.read<NguoiThueProvider>().fetchAll();
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      }
    });
  }
  void _handleTerminateContract() {
    showDialog(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: "Xác nhận kết thúc hợp đồng",
        content: "Bạn có chắc chắn muốn kết thúc hợp đồng này không? Hệ thống sẽ kiểm tra công nợ và chốt ngày trả phòng thực tế.",
        textConfirm: "Kết thúc",
        isDangerous: true,
        onConfirm: () async {
          // 1. Đóng dialog xác nhận trước
          Navigator.pop(dialogContext);

          try {
            // 2. Gọi ViewModel thực hiện kết thúc hợp đồng
            bool success = await vm.terminateHopDong(vm.hopDong.hopDongID);

            if (success && mounted) {
              // Fetch lại dữ liệu các Provider liên quan
              await context.read<PhongProvider>().getListPhong();
              await context.read<NguoiThueProvider>().fetchAll();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kết thúc hợp đồng thành công!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context, true); // Quay về danh sách
              }
            }
          } catch (e) {
            if (mounted) {
              String errorMsg = "Không thể kết thúc hợp đồng do còn vướng công nợ!";

              final err = e as dynamic;
              if (err.response != null && err.response?.data != null) {
                final responseData = err.response?.data;
                if (responseData is Map && responseData['message'] != null) {
                  final message = responseData['message'];
                  if (message is List) {
                    errorMsg = message.join('\n');
                  } else {
                    errorMsg = message.toString();
                  }
                }
              } else {
                errorMsg = e.toString().replaceAll("Exception: ", "");
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    errorMsg,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        },
      ),
    );
  }
}


Widget _tenantInfo(HopDongDTO hopDong) {
  // Mặc định màu sắc và chữ dựa theo trạng thái hợp đồng
  String statusText = "Không rõ";
  Color textColor = Colors.black;
  Color bgColor = Colors.grey.shade200;

  switch (hopDong.trangThai) {
    case 0:
      statusText = "Chờ hiệu lực";
      textColor = const Color(0xffB45309); // vàng
      bgColor = const Color(0xffFEF3C7);
      break;
    case 1:
      statusText = "Đang hoạt động";
      textColor = Colors.green[700]!; // Xanh lá
      bgColor = const Color(0xffE8F3E7);
      break;
    case 2:
      statusText = "Đã kết thúc";
      textColor = const Color(0xff4B5563); // Xám
      bgColor = const Color(0xffF3F4F6);
      break;
  }
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Color(0xffDCE6FF),
            borderRadius: BorderRadius.circular(35),
          ),
          alignment: Alignment.center,

          child: Text(
            vietTat(hopDong.nguoithue.hoTen),
            style: TextStyle(
              color: Color(0xff3B5DD8),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hopDong.nguoithue.hoTen,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Phòng ${hopDong.phong.tenPhong}",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: textColor, size: 10),
                  SizedBox(width: 5),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _thongTinThuePhong(HopDongDTO hopDong) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        const Text(
          "Thông tin thuê phòng",
          style: TextStyle(
            color: Color(0xff2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),

        _item(
          "Giá thuê",
          "${formatMoney(hopDong.giaPhongThucTe)}/tháng",
          color: Color(0xff2E7D32),
        ),
        _item("Tiền đặt cọc", formatMoney(hopDong.tienCoc)),
        _item("Ngày bắt đầu", formatDate(hopDong.ngayKy)),
        _item("Hạn hợp đồng", formatDate(hopDong.ngayHetHan)),
        _item(
          "Ghi chú",
          hopDong.ghiChu??'',
          color: Color(0xff888888),
        ),
      ],
    ),
  );
}

Widget _item(String title, String value, {Color color = Colors.black}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color,
          ),
        ),
      ),
    ],
  );
}

Widget _anhHopDong(BuildContext context, List<String> dsAnh) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hợp đồng đã ký",
          style: TextStyle(
            color: Color(0xff2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 12),

        if (dsAnh.isEmpty)
          Row(
            children: [
              Icon(Icons.image_not_supported_outlined,
                  color: Colors.grey.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                "Chưa có ảnh hợp đồng",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          )
        else
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => XemAnhHopDong(dsAnh: dsAnh),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffEAEAEA)),
              ),
              child: Row(
                children: [
                  //anhr bìa là ảnh đầu tiên
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      bottomLeft: Radius.circular(11),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          dsAnh.first,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.broken_image,
                                color: Colors.grey.shade400),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bản hợp đồng giấy",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green.shade600, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              "${dsAnh.length} ảnh đã upload",
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Nút xem
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xffF0F7F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.photo_library_outlined,
                              size: 14, color: Color(0xff2E7D32)),
                          SizedBox(width: 4),
                          Text(
                            "Xem",
                            style: TextStyle(
                              color: Color(0xff2E7D32),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}


Widget _chiTietPhongButton(BuildContext context, ChiTietHopDongViewModel vm) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: vm.isLoadingPhong
          ? null // Khóa nút khi đang gọi API
          : () async {
        final itemPhong = await vm.getInforPhong(vm.hopDong.phongID);
        if (!context.mounted) return;

        if (itemPhong != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhongChiTiet(room: itemPhong),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Không tìm thấy thông tin phòng!"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: vm.isLoadingPhong
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xff2E7D32),
        ),
      ):Text(
        "Chi tiết Phòng ${vm.hopDong.phong.tenPhong}",
        style: TextStyle(
          color: Color(0xff1D2433),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _actionHopDongButton({
  required String title,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffE53E3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// Menu Pop-up góc trên bên phải
Widget _menu(BuildContext context, ChiTietHopDongViewModel vm) {
  return Theme(
    data: Theme.of(context).copyWith(
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    child: PopupMenuButton<int>(
      offset: const Offset(0, 42), // Đẩy menu xuống ngay bên dưới icon 3 chấm
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xffF3F3F3),
          borderRadius: BorderRadius.circular(36),
        ),
        child: const Icon(Icons.more_vert, color: Colors.black, size: 18),
      ),
      onSelected: (item) async {
        if (item == 1) {
          // Cập nhật hợp đồng
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HopDongForm(hopDong: vm.hopDong),
            ),
          );

          if (result != null) {
            if (result is HopDong) {
              vm.updateHopDongData(result);
            } else if (result == true) {
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            }
          }
        } else if (item == 2) {
          if (vm.hopDong.trangThai == 0) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Hợp đồng chưa có hiệu lực, không thể gia hạn. Vui lòng chọn 'Cập nhật hợp đồng'!",
                  ),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            return;
          }

          // 2. Chuyển sang trang GiaHanHopDongPage và truyền HopDongDTO sang
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => GiaHanHopDongPage(hopDong: vm.hopDong),
            ),
          );

          // 3. Nếu gia hạn thành công (GiaHanHopDongPage trả về true),
          // đóng màn chi tiết để quay về danh sách làm mới dữ liệu
          if (result == true && context.mounted) {
            Navigator.pop(context, true);
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.edit_document, color: Color(0xff4F46E5), size: 20),
              SizedBox(width: 12),
              Text(
                'Cập nhật hợp đồng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D2433),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.update, color: Color(0xff2E7D32), size: 20),
              SizedBox(width: 12),
              Text(
                'Gia hạn hợp đồng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D2433),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}