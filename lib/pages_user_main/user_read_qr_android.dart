import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ReadQRANDROID extends StatefulWidget {
  const ReadQRANDROID({super.key});

  @override
  State<ReadQRANDROID> createState() => _ReadQRANDROIDState();
}

class _ReadQRANDROIDState extends State<ReadQRANDROID> {
  Uint8List bytes = Uint8List(0);
  late final TextEditingController _inputController;
  late final TextEditingController _outputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _outputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Widget _actionButton({
    required String label,
    required double width,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(Size.fromWidth(width)),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(Colors.lightBlue),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        side: WidgetStateProperty.all(
          const BorderSide(color: Colors.lightBlue),
        ),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.lightBlue),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeSelect(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Códigos QR y Códigos de barras'),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withValues(alpha: 0.2),
          child: Builder(
            builder: (BuildContext context) {
              return ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 50.0,
                          left: 50.0,
                          top: 25.0,
                        ),
                        child: _buttonGroupUp(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: colorContainer(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLines: 3,
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(color: Colors.black),
                                  controller: _outputController,
                                  decoration: InputDecoration(
                                    labelText: 'Texto escaneado',
                                    labelStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _actionButton(
                                      label: 'Copiar',
                                      width: 100,
                                      onPressed: () {
                                        if (_outputController.text.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: 'No hay nada para copiar',
                                          );
                                        } else {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: _outputController.text,
                                            ),
                                          );
                                          Fluttertoast.showToast(
                                            msg: 'Se copió al portapapeles',
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    _actionButton(
                                      label: 'Compartir',
                                      width: 100,
                                      onPressed: () {
                                        if (_outputController.text.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: 'No hay nada para compartir',
                                          );
                                        } else {
                                          Share.share(_outputController.text);
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    _actionButton(
                                      label: 'Limpiar',
                                      width: 100,
                                      onPressed: () {
                                        _outputController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: colorContainer(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text(
                                  '¿Desea crear un código QR?',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Ingrese información en el siguiente cuadro de texto y luego genere el código',
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  validator: (value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'Este campo no puede estar vacío';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    _generateBarCode(value, context);
                                  },
                                  maxLines: 3,
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(color: Colors.black),
                                  controller: _inputController,
                                  decoration: InputDecoration(
                                    labelText:
                                        'Texto para convertir a código QR',
                                    labelStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 125.0,
                          left: 125.0,
                          top: 5.0,
                        ),
                        child: _buttonGroupDown(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List qrBytes, BuildContext sheetContext) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 350,
                child: qrBytes.isEmpty
                    ? const Text('Sin código')
                    : Image.memory(qrBytes),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.lightGreen,
                            ),
                            overlayColor: WidgetStateProperty.all(
                              Colors.lightGreen.shade200,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await Gal.putImageBytes(qrBytes);
                              if (sheetContext.mounted) {
                                Fluttertoast.showToast(
                                  msg: 'Se guardó en la galería',
                                );
                                Navigator.pop(sheetContext);
                                _inputController.clear();
                              }
                            } catch (_) {
                              Fluttertoast.showToast(
                                msg: 'No se pudo guardar',
                              );
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Guardar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.grey,
                            ),
                            overlayColor: WidgetStateProperty.all(
                              Colors.lightGreen.shade200,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              bytes = Uint8List(0);
                            });
                            Navigator.pop(sheetContext);
                            _inputController.clear();
                          },
                          child: const Center(
                            child: Text(
                              '    Salir    ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonGroupUp() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: _scan,
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/scanPhone.png'),
                    ),
                    const Expanded(flex: 1, child: Text('Escanear')),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: _scanPhoto,
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/galleryPicture.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Seleccionar una imagen',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonGroupDown() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                _generateBarCode(_inputController.text, context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('images/createQR.png'),
                      ),
                    ),
                    const Expanded(flex: 1, child: Text('Generar QR')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _scan() async {
    final status = await Permission.camera.request();
    if (!status.isGranted || !mounted) {
      Fluttertoast.showToast(msg: 'Permiso de cámara requerido');
      return;
    }
    final String? barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const _QrCameraScannerPage(),
      ),
    );
    if (barcode != null && barcode.isNotEmpty) {
      _outputController.text = barcode;
    }
  }

  Future<void> _scanPhoto() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage == null) return;

      final controller = MobileScannerController(autoStart: false);
      try {
        final BarcodeCapture? capture = await controller.analyzeImage(
          pickedImage.path,
        );
        final String? code = capture?.barcodes.firstOrNull?.rawValue;
        if (code != null && code.isNotEmpty) {
          _outputController.text = code;
        } else {
          Fluttertoast.showToast(msg: 'Intente con otro código');
        }
      } finally {
        await controller.dispose();
      }
    } catch (_) {
      Fluttertoast.showToast(msg: 'Intente con otro código');
    }
  }

  Future<void> _generateBarCode(String inputCode, BuildContext context) async {
    if (inputCode.isEmpty) {
      Fluttertoast.showToast(msg: 'No hay información para crear QR');
      return;
    }

    const double qrSize = 400;
    final painter = QrPainter(
      data: inputCode,
      version: QrVersions.auto,
      gapless: true,
    );
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, qrSize, qrSize),
      Paint()..color = Colors.white,
    );
    painter.paint(canvas, const Size(qrSize, qrSize));
    final picture = recorder.endRecording();
    final image = await picture.toImage(qrSize.toInt(), qrSize.toInt());
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null || !context.mounted) return;

    final Uint8List result = byteData.buffer.asUint8List();
    setState(() {
      bytes = result;
    });

    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          padding: const EdgeInsets.all(30.0),
          height: 600,
          child: _qrCodeWidget(bytes, sheetContext),
        );
      },
    );
  }
}

class _QrCameraScannerPage extends StatefulWidget {
  const _QrCameraScannerPage();

  @override
  State<_QrCameraScannerPage> createState() => _QrCameraScannerPageState();
}

class _QrCameraScannerPageState extends State<_QrCameraScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear código'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: barColor()),
        ),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (BarcodeCapture capture) {
          if (_handled) return;
          final String? code = capture.barcodes.firstOrNull?.rawValue;
          if (code != null && code.isNotEmpty) {
            _handled = true;
            Navigator.of(context).pop(code);
          }
        },
      ),
    );
  }
}
