import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:fluttersupabase/constants.dart';

class ReadQRIOS extends StatefulWidget {
  const ReadQRIOS({Key? key}) : super(key: key);
  @override
  State<ReadQRIOS> createState() => _ReadQRIOSState();
}

class _ReadQRIOSState extends State<ReadQRIOS> {
  String? _qrInfo = 'Escaner';
  bool _camState = false;

  _qrCallback(String? code) {
    setState(() {
      _camState = false;
      _qrInfo = code;
    });
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _scanCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Lector de códigos QR y Barras',
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: barColor(),
              ),
            ),
          ),
          body: Container(
            color: Colors.grey.withOpacity(0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: QRBarScannerCamera(
                      offscreenBuilder: (context) {
                        return Column(
                          children: [
                            const Text('La cámara esta pausada'),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/userMain');
                                },
                                child: const Text('Salir'))
                          ],
                        );
                      },
                      onError: (context, error) {
                        return Column(
                          children: [
                            const Text(
                                'No se han otorgado permisos, por favor, elimine los datos de la aplicación desde configuraciones'),
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/userMain');
                                },
                                child: const Text('Salir'))
                          ],
                        );
                      },
                      qrCodeCallback: (code) {
                        _qrCallback(code);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  _camState
                      ? const Text('Enfoque hacia código QR o código de barras')
                      : SelectableText(
                          _qrInfo.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                ],
              ),
            ),
          )),
    );
  }
}
