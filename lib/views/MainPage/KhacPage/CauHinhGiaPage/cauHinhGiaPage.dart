import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/Provider/cau_hinh_gia_provider.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../modelviews/MainPage/KhacPage/CauHinhGiaPage/CauHinhGiaPageViewModel.dart';

class CauHinhGiaPage extends StatefulWidget {
  const CauHinhGiaPage({super.key});

  @override
  State<CauHinhGiaPage> createState() => _CauHinhGiaPageState();
}

class _CauHinhGiaPageState extends State<CauHinhGiaPage> {
  late final CauHinhGiaPageViewModel _viewModel;

  static const Color _primaryGreen = Color(0xFF4E7A50);
  static const Color _backgroundColor = Color(0xFFF7F9F7);

  @override
  void initState() {
    super.initState();
    final provider = context.read<CauHinhGiaProvider>();
    _viewModel = CauHinhGiaPageViewModel(provider: provider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadData();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await _viewModel.saveConfig();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật đơn giá thành công!'),
          backgroundColor: _primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (_viewModel.provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.provider.errorMessage!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CauHinhGiaProvider>();
    final cauHinhGia = provider.cauHinhGia;

    return ChangeNotifierProvider<CauHinhGiaPageViewModel>.value(
      value: _viewModel,
      child: Consumer<CauHinhGiaPageViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: _backgroundColor,
            appBar: AppBar(
              title: const Text(
                'Cấu hình giá',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: (provider.isLoading && !vm.isInitLoaded)
                ? const Center(
                    child: CircularProgressIndicator(color: _primaryGreen),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: vm.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thẻ Lần cập nhật gần nhất
                          if (cauHinhGia != null &&
                              cauHinhGia.updatedAt != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF5F0),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFD6E4D7),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.history,
                                    color: _primaryGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Lần cập nhật gần nhất: ${DateFormat('dd/MM/yyyy HH:mm').format(cauHinhGia.updatedAt!.toLocal())}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: _primaryGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Card Cấu hình đơn giá
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Thông tin giá dịch vụ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryGreen,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Ô nhập Giá điện
                                _buildPriceInputField(
                                  controller: vm.giaDienController,
                                  label: "Đơn giá điện",
                                  unit: "đ / kWh",
                                  icon: Icons.electric_bolt,
                                  iconColor: Colors.amber.shade800,
                                  iconBg: const Color(0xFFFFF8E1),
                                  hint: "VD: 3.500",
                                  validator: (v) =>
                                      vm.validateGia(v, "Đơn giá điện"),
                                ),

                                const SizedBox(height: 16),

                                // Ô nhập Giá nước
                                _buildPriceInputField(
                                  controller: vm.giaNuocController,
                                  label: "Đơn giá nước",
                                  unit: "đ / m³",
                                  icon: Icons.water_drop,
                                  iconColor: Colors.blue,
                                  iconBg: const Color(0xFFE3F2FD),
                                  hint: "VD: 15.000",
                                  validator: (v) =>
                                      vm.validateGia(v, "Đơn giá nước"),
                                ),

                                const SizedBox(height: 12),
                                Text(
                                  "Đơn giá dùng để tính tự động khi ghi chỉ số điện nước và lập hóa đơn phòng hàng tháng.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Nút Lưu Cấu Hình
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : _handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryGreen,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: provider.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      "Lưu cấu hình giá",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildPriceInputField({
    required TextEditingController controller,
    required String label,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            DinhDangGiaVN(),
          ],
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ),
            suffixText: unit,
            suffixStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
