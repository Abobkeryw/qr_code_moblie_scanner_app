import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '/widgets/mobile_scanner_simple.dart';
import '/page/result_page.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final MobileScannerController _controller = MobileScannerController();

  void _onQRDetect(String code) {
    print("Scanned: $code");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage(result: code)),
    );
  }

  Future<void> _toggleFlash() async {
    await _controller.toggleTorch();
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Read image as bytes
        final bytes = await image.readAsBytes();

        // Analyze image bytes with MobileScannerController
        final result = await _controller.analyzeImage('$bytes');

        if (result != null && result.barcodes.isNotEmpty) {
          final scannedCode = result.barcodes.first.rawValue ?? 'Unknown QR';
          _onQRDetect(scannedCode);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No QR code found in the image')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to analyze image: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Scan QR Code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Place QR code inside the frame to scan\nAvoid shake to get result quickly',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: MobileScannerSimple(
                onDetect: _onQRDetect,
                controller: _controller,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Scanning Code...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bottomIcon('images/Flash_light.png', _toggleFlash),
                const SizedBox(width: 10),
                _bottomIcon('images/Gallary.png', _pickImageFromGallery),
              ],
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                // You can replace this with your own manual trigger or remove it
                _onQRDetect('Manual QR Code Triggered');
              },
              height: 60,
              minWidth: 370,
              color: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Place Camera Code',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(path, height: 25, width: 25),
    );
  }
}
