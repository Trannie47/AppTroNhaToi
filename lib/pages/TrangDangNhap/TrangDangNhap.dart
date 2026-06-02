import 'package:AppTroNhaToi/modelviews/TrangDangNhap/TrangDangNhap.dart';
import 'package:flutter/material.dart';

import '../MainPage/MainPage.dart';

class TrangDangNhap extends StatefulWidget {
  const TrangDangNhap({Key? key}) : super(key: key);

  @override
  State<TrangDangNhap> createState() => _TrangDangNhapState();
}

class _TrangDangNhapState extends State<TrangDangNhap> {
  final TrangDangNhapModelView vm = TrangDangNhapModelView();

  @override
  void initState() {
    super.initState();

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    checkLogin();
  }

  Future<void> checkLogin() async {
    bool success = await vm.checkRememberedLogin();

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPage(),
        ),
      );
    }
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
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
    );
  }

  @override
  void dispose() {
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
            child: Image.asset(
              'assets/images/bg_tro.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: vm.errorServer != null ? 0 : -100,
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
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vm.errorServer ?? "",
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
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(
                            Icons.home,
                            size: 100,
                            color: Colors.white,
                          ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context)
                                    .size
                                    .height -
                                MediaQuery.of(context)
                                    .padding
                                    .top -
                                MediaQuery.of(context)
                                    .padding
                                    .bottom -
                                220,
                      ),
                      child: Align(
                        alignment:
                            Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration:
                              const Duration(
                                milliseconds: 250,
                              ),
                          margin:
                              const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                16,
                              ),
                          padding:
                              const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(
                                  alpha: 0.9,
                                ),
                            borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                          ),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              const Align(
                                alignment:
                                    Alignment.centerLeft,
                                child:
                                    Text("Tài khoản"),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              TextField(
                                controller:
                                    vm.userController,
                                decoration:
                                    inputStyle(
                                      "Nhập tài khoản",
                                      vm.errorUser,
                                    ),
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              const Align(
                                alignment:
                                    Alignment.centerLeft,
                                child:
                                    Text("Mật khẩu"),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              TextField(
                                controller:
                                    vm.passController,
                                obscureText:
                                    vm.isHidden,
                                decoration:
                                    inputStyle(
                                      "Mật khẩu",
                                      vm.errorPass,
                                    ).copyWith(
                                      suffixIcon:
                                          IconButton(
                                            icon: Icon(
                                              vm.isHidden
                                                  ? Icons
                                                      .visibility_off
                                                  : Icons
                                                      .visibility,
                                              color:
                                                  Colors
                                                      .grey,
                                            ),
                                            onPressed:
                                                vm.togglePassword,
                                          ),
                                    ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Row(
                                children: [
                                  Checkbox(
                                    value:
                                        vm.remember,
                                    onChanged:
                                        (value) {
                                      vm.setRemember(
                                        value!,
                                      );
                                    },
                                  ),
                                  const Text(
                                    "Ghi nhớ mật khẩu",
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              SizedBox(
                                width:
                                    double.infinity,
                                height: 50,
                                child:
                                    ElevatedButton(
                                      style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(
                                                  0xFF2D7A3A,
                                                ),
                                            shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10,
                                                      ),
                                                ),
                                          ),
                                      onPressed:
                                          () async {
                                        bool success =
                                            await vm
                                                .dangNhap();

                                        if (success &&
                                            mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (
                                                    context,
                                                  ) =>
                                                      const MainPage(),
                                            ),
                                          );
                                        }
                                      },
                                      child:
                                          const Text(
                                            "Đăng nhập",
                                            style:
                                                TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color:
                                                      Colors.white,
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

