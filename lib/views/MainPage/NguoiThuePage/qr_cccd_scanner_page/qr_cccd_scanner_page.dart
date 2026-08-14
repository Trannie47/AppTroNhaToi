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

  // Cấu hình riêng cho quét QR CCCD:
  // - Chỉ nhận dạng QR code (bỏ qua các format khác) -> mỗi frame xử lý
  //   nhanh hơn vì không phải dò thêm barcode/PDF417/Aztec...
  // - detectionSpeed: noDuplicates -> quét liên tục, chỉ bỏ qua khi bắt
  //   được đúng 1 mã giống hệt lần trước (khác với "normal" vốn có độ trễ
  //   cố định giữa các lần detect, làm chậm việc bắt QR CCCD vốn dày dữ liệu).
  // - returnImage: false -> không cần ảnh snapshot, giảm tải xử lý mỗi frame.
  // - cameraResolution cao hơn -> ảnh nét/chi tiết hơn khi máy đã lấy nét
  //   đúng, giúp giải mã QR CCCD (dày module) dễ hơn.
  late final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
    cameraResolution: const Size(1920, 1080),
  );

  // mobile_scanner (>= 7.1.0) đã hỗ trợ tap-to-focus THẬT SỰ (native, không
  // restart/zoom camera nên không có chớp), bật bằng tapToFocus: true ở
  // dưới. Đồng thời tự động chọn ống kính lấy nét gần tốt nhất (ví dụ lens
  // wide trên iPhone thường lấy nét gần hơn lens chính) — đúng gốc rễ vấn
  // đề iPhone 12 không quét được khi cầm CCCD gần camera.
  //
  // LƯU Ý: 2 API này (tapToFocus, getBestCloseRangeScanningLens) chỉ có từ
  // mobile_scanner 7.1.0 trở lên — nếu build lỗi thiếu API, kiểm tra lại
  // version trong pubspec.yaml và chạy `flutter pub upgrade mobile_scanner`.

  // Zoom hiện tại (0.0 -> 1.0, chuẩn của mobile_scanner) và mốc zoom lúc
  // bắt đầu chụm/mở 2 ngón, dùng để tính zoom mới khi pinch.
  double _zoomHienTai = 0.0;
  double _zoomLucBatDauPinch = 0.0;

  @override
  void initState() {
    super.initState();

    vm = QRCCCDScannerPageViewModel();

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _chonOngKinhLayNetGan();
  }

  /// Tự động chọn ống kính lấy nét gần tốt nhất hiện có (nếu máy hỗ trợ),
  /// để scan CCCD ở khoảng cách gần không bị "quá gần, không lấy nét được"
  /// như camera chính của 1 số máy (ví dụ iPhone 12).
  Future<void> _chonOngKinhLayNetGan() async {
    try {
      final lens = await _controller.getBestCloseRangeScanningLens();
      if (lens != null && mounted) {
        await _controller.switchCamera(SelectCamera(lensType: lens));
      }
    } catch (_) {
      // Máy không hỗ trợ / thư viện chưa có API này -> bỏ qua, vẫn dùng
      // lens mặc định, không làm crash trang quét.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    vm.dispose();
    super.dispose();
  }

  void _dong() {
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // CAMERA
            Positioned.fill(
              child: GestureDetector(
                // Pinch 2 ngón để phóng to/thu nhỏ camera. Gesture chụm/mở
                // (2 pointer) và tap-to-focus của MobileScanner (1 pointer)
                // không đụng nhau vì Flutter tự phân xử theo loại cử chỉ,
                // nên vẫn chạm để focus bình thường được.
                onScaleStart: (details) {
                  _zoomLucBatDauPinch = _zoomHienTai;
                },
                onScaleUpdate: (details) {
                  final zoomMoi =
                      (_zoomLucBatDauPinch + (details.scale - 1) / 4).clamp(
                        0.0,
                        1.0,
                      );

                  if (zoomMoi == _zoomHienTai) return;

                  _zoomHienTai = zoomMoi;
                  _controller.setZoomScale(zoomMoi);
                },
                child: MobileScanner(
                  controller: _controller,
                  tapToFocus: true, // native tap-to-focus, không chớp màn hình
                  onDetect: (capture) {
                    if (vm.scanned) return;
                    vm.scanned = true;

                    final code = capture.barcodes.first.rawValue;
                    if (code == null) return;

                    Navigator.pop(context, code);
                  },
                ),
              ),
            ),

            // OVERLAY MỜ 4 GÓC
            _buildOverlay(context),

            // NÚT THOÁT
            // Đặt trong SafeArea nên top chỉ cần padding cố định, không phải
            // tự cộng MediaQuery.padding.top thủ công (dễ lệch/chưa ổn định
            // ở frame đầu trên iOS khiến nút "trông thấy nhưng bấm không
            // trúng"). Tăng kích thước lên 44x44 theo chuẩn tối thiểu của
            // Apple (Human Interface Guidelines) và set hitTestBehavior
            // opaque để toàn bộ vùng tròn đều nhận tap, không chỉ phần có
            // vẽ màu.
            Positioned(
              top: 12,
              right: 16,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _dong,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
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
          child: IgnorePointer(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        // BOTTOM
        Positioned(
          top: boxTop + boxSize,
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        // LEFT
        Positioned(
          top: boxTop,
          left: 0,
          width: boxLeft,
          height: boxSize,
          child: IgnorePointer(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        // RIGHT
        Positioned(
          top: boxTop,
          right: 0,
          width: boxLeft,
          height: boxSize,
          child: IgnorePointer(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ),

        // KHUNG VUÔNG TRẮNG
        Positioned(
          top: boxTop,
          left: boxLeft,
          width: boxSize,
          height: boxSize,
          child: IgnorePointer(
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
