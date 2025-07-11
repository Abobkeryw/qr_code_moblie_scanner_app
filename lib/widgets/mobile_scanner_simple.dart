import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MobileScannerSimple extends StatefulWidget {
  final void Function(String code) onDetect;
  final MobileScannerController controller;

  const MobileScannerSimple({
    super.key,
    required this.onDetect,
    required this.controller,
  });

  @override
  State<MobileScannerSimple> createState() => _MobileScannerSimpleState();
}

class _MobileScannerSimpleState extends State<MobileScannerSimple> {
  Barcode? _barcode;
  bool _isSaving = false;

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (_isSaving) return;

    final scanned = barcodes.barcodes.firstOrNull;
    if (scanned == null || scanned.rawValue == null) return;

    final String code = scanned.rawValue!;
    setState(() => _barcode = scanned);
    _isSaving = true;

    await _saveToSharedPrefs(code);
    widget.onDetect(code);

    await Future.delayed(const Duration(seconds: 3)); // cooldown
    _isSaving = false;
  }

  Future<void> _saveToSharedPrefs(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> current = prefs.getStringList('qr_codes') ?? [];

    final Map<String, dynamic> entry = {
      'value': code,
      'timestamp': DateTime.now().toIso8601String(),
    };

    current.add(json.encode(entry));
    await prefs.setStringList('qr_codes', current);
  }

  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }
    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: widget.controller,
          onDetect: _handleBarcode,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 30,
            color: const Color.fromRGBO(0, 0, 0, 0.4),
            child: Center(child: _barcodePreview(_barcode)),
          ),
        ),
      ],
    );
  }
}
