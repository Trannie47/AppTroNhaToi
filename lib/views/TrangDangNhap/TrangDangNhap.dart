import 'package:AppTroNhaToi/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import '../MainPage/MainPage.dart';

class TrangDangNhap extends StatefulWidget {
  const TrangDangNhap({Key? key}) : super(key: key);

  @override
  State<TrangDangNhap> createState() => _TrangDangNhapState();
}

class _TrangDangNhapState extends State<TrangDangNhap> {
  final AuthViewModel vm = AuthViewModel();

  // 🌟 2. Khai báo các Controller và biến giao diện trực tiếp tại View để dễ dọn dẹp bộ nhớ
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isHidden = true; // Biến kiểm soát ẩn hiện mật khẩu
  String? _errorServer; // Biến hứng lỗi từ Server trả về

  @override
  void initState() {
    super.initState();

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  InputDecoration inputStyle(String hint, String? error) {
    return InputDecoration(
      hintText: hint,
      errorText: error,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg_tro.png', fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          // Thanh thông báo lỗi giật từ trên đỉnh xuống
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _errorServer != null ? 0 : -100,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorServer ?? "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  'assets/images/Logo_NoBG.png',
                  width: 140,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.home, size: 100, color: Colors.white),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            220,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Tài khoản",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextField(
                                controller: _userController,
                                decoration: inputStyle(
                                  "Nhập tài khoản hoặc email",
                                  null,
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Mật khẩu",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Ô nhập mật khẩu
                              TextField(
                                controller: _passController,
                                obscureText: _isHidden,
                                decoration: inputStyle("Mật khẩu", null).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isHidden
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      // Đảo trạng thái ẩn hiện mật khẩu trực tiếp tại View
                                      setState(() {
                                        _isHidden = !_isHidden;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D7A3A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Xóa thông báo lỗi cũ trước khi bấm test lại
                                    setState(() {
                                      _errorServer = null;
                                    });

                                    // Lấy chữ thô từ 2 ô nhập liệu
                                    final inputAccount = _userController.text
                                        .trim();
                                    final inputPassword = _passController.text
                                        .trim();

                                    if (inputAccount.isEmpty ||
                                        inputPassword.isEmpty) {
                                      setState(() {
                                        _errorServer =
                                            "Vui lòng nhập đầy đủ thông tin!";
                                      });
                                      return;
                                    }

                                    final userResult = await vm.login(
                                      inputAccount,
                                      inputPassword,
                                    );

                                    if (userResult != null && mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainPage(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        _errorServer =
                                            "Tài khoản hoặc mật khẩu không chính xác!";
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
