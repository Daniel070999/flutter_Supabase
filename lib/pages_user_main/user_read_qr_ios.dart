import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ReadQRIOS extends StatefulWidget {
  const ReadQRIOS({super.key});

  @override
  State<ReadQRIOS> createState() => _ReadQRIOSState();
}

class _ReadQRIOSState extends State<ReadQRIOS> {
  final MobileScannerController _scannerController = MobileScannerController();
  String? _qrInfo = 'Escaner';
  bool _camState = true;

  void _qrCallback(String? code) {
    if (!mounted) return;
    _scannerController.stop();
    setState(() {
      _camState = false;
      _qrInfo = code;
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeSelect(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lector de códigos QR y Barras'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: barColor(),
            ),
          ),
        ),
        body: Container(
          color: Colors.grey.withValues(alpha: 0.2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: MobileScanner(
                    controller: _scannerController,
                    errorBuilder: (context, error, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No se han otorgado permisos, por favor verifique la configuración de la aplicación',
                            textAlign: TextAlign.center,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/userMain',
                              );
                            },
                            child: const Text('Salir'),
                          ),
                        ],
                      );
                    },
                    onDetect: (BarcodeCapture capture) {
                      final String? code =
                          capture.barcodes.firstOrNull?.rawValue;
                      if (code != null && _camState) {
                        _qrCallback(code);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 40),
                _camState
                    ? const Text('Enfoque hacia código QR o código de barras')
                    : SelectableText(
                        _qrInfo.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
