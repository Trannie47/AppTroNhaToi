import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/qr_cccd_scanner_page/qr_cccd_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCCCDScannerPage extends StatefulWidget {
  const QRCCCDScannerPage({super.key});

  @override
  State<QRCCCDScannerPage> createState() => _QRCCCDScannerPageState();
}

class _QRCCCDScannerPageState extends State<QRCCCDScannerPage> {
  late QRCCCDScannerPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = QRCCCDScannerPageViewModel();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // CAMERA
          MobileScanner(
            onDetect: (capture) {
              if (vm.scanned) return;
              vm.scanned = true;

              final code = capture.barcodes.first.rawValue;
              if (code == null) return;

              Navigator.pop(context, code);
            },
          ),

          // OVERLAY MỜ 4 GÓC
          _buildOverlay(context),

          // NÚT THOÁT
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),

          // TEXT HƯỚNG DẪN
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Đưa mã QR trên thẻ CCCD vào khung",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Hệ thống sẽ tự động nhận diện",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    const boxSize = 260.0;
    final boxLeft = (screenW - boxSize) / 2;
    final boxTop = (screenH - boxSize) / 2 - 40;

    return Stack(
      children: [
        // 4 vùng mờ xung quanh khung quét
        // TOP
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: boxTop,
          child: Container(color: Colors.black.withOpacity(0.6)),
        ),
        // BOTTOM
        Positioned(
          top: boxTop + boxSize,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.black.withOpacity(0.6)),
        ),
        // LEFT
        Positioned(
          top: boxTop,
          left: 0,
          width: boxLeft,
          height: boxSize,
          child: Container(color: Colors.black.withOpacity(0.6)),
        ),
        // RIGHT
        Positioned(
          top: boxTop,
          right: 0,
          width: boxLeft,
          height: boxSize,
          child: Container(color: Colors.black.withOpacity(0.6)),
        ),

        // KHUNG VUÔNG TRẮNG
        Positioned(
          top: boxTop,
          left: boxLeft,
          width: boxSize,
          height: boxSize,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // 4 GÓC L-SHAPE
                ..._buildCorners(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 4 góc chữ L màu xanh lá
  List<Widget> _buildCorners() {
    const color = Color(0xff2D7A3A);
    const size = 24.0;
    const thickness = 3.5;
    const radius = 6.0;

    Widget corner({
      bool top = false,
      bool bottom = false,
      bool left = false,
      bool right = false,
    }) {
      return Positioned(
        top: top ? 0 : null,
        bottom: bottom ? 0 : null,
        left: left ? 0 : null,
        right: right ? 0 : null,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              color: color,
              thickness: thickness,
              radius: radius,
              flipH: right,
              flipV: bottom,
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, right: true),
      corner(bottom: true, left: true),
      corner(bottom: true, right: true),
    ];
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double radius;
  final bool flipH;
  final bool flipV;

  const _CornerPainter({
    required this.color,
    required this.thickness,
    required this.radius,
    this.flipH = false,
    this.flipV = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.save();

    if (flipH || flipV) {
      canvas.translate(flipH ? size.width : 0, flipV ? size.height : 0);
      canvas.scale(flipH ? -1 : 1, flipV ? -1 : 1);
    }

    final path = Path()
      ..moveTo(size.width, thickness / 2)
      ..lineTo(radius + thickness / 2, thickness / 2)
      ..arcToPoint(
        Offset(thickness / 2, radius + thickness / 2),
        radius: Radius.circular(radius),
      )
      ..lineTo(thickness / 2, size.height);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
