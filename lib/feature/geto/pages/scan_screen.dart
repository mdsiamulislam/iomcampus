import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isScanned = false;
  String? scannedData;

  void _handleBarcode(BarcodeCapture capture) {
    if (isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      final String? code = barcode.rawValue;

      if (code != null && code.isNotEmpty) {
        setState(() {
          isScanned = true;
          scannedData = code;
        });

        debugPrint('✅ QR Code Scanned: $code');
        _showScannedDataSheet(code);
      }
    }
  }

  void _showScannedDataSheet(String data) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'QR Code Scanned!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SelectableText(
                data,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isScanned = false;
                        scannedData = null;
                      });
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan Again'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.green),
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.back();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Simple Mobile Scanner without controller
          MobileScanner(
            onDetect: _handleBarcode,
          ),

          // Overlay with scanning area
          CustomPaint(
            painter: ScannerOverlay(),
            child: Container(),
          ),

          // Instructions
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Position the QR code within the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Scanned indicator
          if (isScanned)
            Container(
              color: Colors.green.withOpacity(0.3),
              child: const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutSize = size.width * 0.7;
    final cutoutLeft = (size.width - cutoutSize) / 2;
    final cutoutTop = (size.height - cutoutSize) / 2;

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cutoutLeft, cutoutTop, cutoutSize, cutoutSize),
          const Radius.circular(16),
        ),
      );

    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withOpacity(0.6),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cutoutLeft, cutoutTop, cutoutSize, cutoutSize),
        const Radius.circular(16),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.green
        ..strokeWidth = 3,
    );

    final cornerLength = 30.0;
    final cornerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Top-left
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop + cornerLength),
      Offset(cutoutLeft, cutoutTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop),
      Offset(cutoutLeft + cornerLength, cutoutTop),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(cutoutLeft + cutoutSize - cornerLength, cutoutTop),
      Offset(cutoutLeft + cutoutSize, cutoutTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft + cutoutSize, cutoutTop),
      Offset(cutoutLeft + cutoutSize, cutoutTop + cornerLength),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop + cutoutSize - cornerLength),
      Offset(cutoutLeft, cutoutTop + cutoutSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft, cutoutTop + cutoutSize),
      Offset(cutoutLeft + cornerLength, cutoutTop + cutoutSize),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(cutoutLeft + cutoutSize - cornerLength, cutoutTop + cutoutSize),
      Offset(cutoutLeft + cutoutSize, cutoutTop + cutoutSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutoutLeft + cutoutSize, cutoutTop + cutoutSize - cornerLength),
      Offset(cutoutLeft + cutoutSize, cutoutTop + cutoutSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}