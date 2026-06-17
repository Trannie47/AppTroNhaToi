import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/HangHoaFormViewModel/HangHoaFormViewModel.dart';
import 'package:flutter/material.dart';

class HangHoaForm extends StatefulWidget {
  final HangHoa? hangHoa;

  const HangHoaForm({super.key, this.hangHoa});

  @override
  State<HangHoaForm> createState() => _HangHoaFormState();
}

class _HangHoaFormState extends State<HangHoaForm> {
  final vm = HangHoaFormViewModel();

  @override
  void initState() {
    super.initState();

    if (widget.hangHoa != null) {
      vm.txtTenHangHoa.text = widget.hangHoa!.tenHangHoa ?? "";

      vm.txtGiaBan.text = widget.hangHoa!.giaBan?.toStringAsFixed(0) ?? "";

      vm.txtGiaNhap.text = widget.hangHoa!.giaNhap?.toStringAsFixed(0) ?? "";

      vm.txtDonVi.text = widget.hangHoa!.donViTinh ?? "";
    }

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  Widget inputBox({
    required String title,
    required TextEditingController controller,
    String? errorText,
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,

          onChanged: (_) {
            if (onChanged != null) {
              onChanged();
            }
          },

          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF5F5F5),
            suffixText: suffix,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hangHoa == null ? "Thêm hàng hóa" : "Chỉnh sửa hàng hóa",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (widget.hangHoa != null)
              Text(
                widget.hangHoa!.tenHangHoa ?? "",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thông tin hàng hóa",
                  style: TextStyle(
                    color: Color(0xff2D7A3A),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20),

                inputBox(
                  title: "Tên hàng hóa",
                  controller: vm.txtTenHangHoa,
                  errorText: vm.errTenHangHoa,
                  onChanged: () {
                    vm.errTenHangHoa = null;
                    vm.notifyListeners();
                  },
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: inputBox(
                        title: "Giá bán",
                        controller: vm.txtGiaBan,
                        errorText: vm.errGiaBan,
                        keyboardType: TextInputType.number,
                        suffix: "đ",
                        onChanged: () {
                          vm.errGiaBan = null;
                          vm.notifyListeners();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: inputBox(
                        title: "Giá nhập",
                        controller: vm.txtGiaNhap,
                        errorText: vm.errGiaNhap,
                        keyboardType: TextInputType.number,
                        suffix: "đ",
                        onChanged: () {
                          vm.errGiaNhap = null;
                          vm.notifyListeners();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: inputBox(
                        title: "Số lượng",
                        controller: vm.txtSoLuong,
                        errorText: vm.errSoLuong,
                        keyboardType: TextInputType.number,
                        onChanged: () {
                          vm.errSoLuong = null;
                          vm.notifyListeners();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: inputBox(
                        title: "Đơn vị",
                        controller: vm.txtDonVi,
                        errorText: vm.errDonVi,
                        onChanged: () {
                          vm.errDonVi = null;
                          vm.notifyListeners();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (vm.kiemTraDuLieu()) {
                    Navigator.pop(
                      context,
                      HangHoa(
                        maHangHoa:
                            widget.hangHoa?.maHangHoa ??
                            DateTime.now().millisecondsSinceEpoch,

                        tenHangHoa: vm.txtTenHangHoa.text,
                        giaBan: double.parse(vm.txtGiaBan.text),
                        giaNhap: double.parse(vm.txtGiaNhap.text),
                        donViTinh: vm.txtDonVi.text,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2D7A3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  widget.hangHoa == null ? "Lưu hàng hóa" : "Lưu thay đổi",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (widget.hangHoa != null) ...[
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, "xoa");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Xóa hàng hóa này",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
