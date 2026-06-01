import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCCCDScannerPage extends StatefulWidget {
  const QRCCCDScannerPage({
    super.key,
  });

  @override
  State<QRCCCDScannerPage> createState() =>
      _QRCCCDScannerPageState();
}

class _QRCCCDScannerPageState
    extends State<QRCCCDScannerPage> {

  bool scanned = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Quét CCCD",
        ),
      ),

      body: MobileScanner(

        onDetect: (capture) {

          if (scanned) return;

          scanned = true;

          final code =
              capture.barcodes.first.rawValue;

          if (code == null) return;

          print(code);
        },
      ),
    );
  }
}