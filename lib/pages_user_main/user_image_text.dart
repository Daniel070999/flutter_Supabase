import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextImage extends StatefulWidget {
  const TextImage({super.key});

  @override
  State<TextImage> createState() => _TextImageState();
}

class _TextImageState extends State<TextImage> {
  bool textScanning = false;
  XFile? imageFile;
  final scannedText = TextEditingController();

  @override
  void dispose() {
    scannedText.dispose();
    super.dispose();
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        if (!mounted) return;
        setState(() {
          textScanning = true;
          imageFile = pickedImage;
        });
        await getRecognisedText(pickedImage);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        textScanning = false;
        imageFile = null;
        scannedText.text = 'Ocurrio un error durante el reconocimiento';
      });
    }
  }

  Future<void> getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final RecognizedText recognisedText = await textDetector.processImage(
        inputImage,
      );
      final buffer = StringBuffer();
      for (final TextBlock block in recognisedText.blocks) {
        for (final TextLine line in block.lines) {
          buffer.writeln(line.text);
        }
      }
      if (mounted) {
        setState(() {
          scannedText.text = buffer.toString();
          textScanning = false;
        });
      }
    } finally {
      await textDetector.close();
    }
  }

  Widget _buttonGroupDownTextImage() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                getImage(ImageSource.camera);
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
                      child: Image.asset('images/camera.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text('Cámara'),
                    ),
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
              onTap: () {
                getImage(ImageSource.gallery);
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
          title: const Text('Texto en imagen'),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withValues(alpha: 0.2),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (textScanning)
                    Platform.isAndroid
                        ? const CircularProgressIndicator()
                        : const CupertinoActivityIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 30.0,
                      left: 30.0,
                      top: 10.0,
                    ),
                    child: _buttonGroupDownTextImage(),
                  ),
                  const SizedBox(height: 10),
                  if (imageFile != null)
                    Image.file(
                      File(imageFile!.path),
                      width: 300,
                      height: 300,
                    ),
                  const SizedBox(height: 10),
                  if (!textScanning && imageFile == null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.grey.shade400,
                        ),
                        width: 150,
                        height: 150,
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey,
                          size: 100.0,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: colorContainer(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: scannedText,
                              maxLines: 10,
                              cursorColor: Colors.blue,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Texto reconocido',
                                labelStyle: const TextStyle(color: Colors.blue),
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
                                  label: 'Escuchar',
                                  width: 150,
                                  onPressed: () {
                                    if (scannedText.text.isNotEmpty) {
                                      Navigator.pushNamed(
                                        context,
                                        '/textToSpeech',
                                        arguments: scannedText.text,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                _actionButton(
                                  label: 'Traducir',
                                  width: 150,
                                  onPressed: () {
                                    if (scannedText.text.isNotEmpty) {
                                      Navigator.pushNamed(
                                        context,
                                        '/translate',
                                        arguments: scannedText.text,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _actionButton(
                                  label: 'Copiar',
                                  width: 100,
                                  onPressed: () {
                                    if (scannedText.text.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: 'No hay nada para copiar',
                                      );
                                    } else {
                                      Clipboard.setData(
                                        ClipboardData(text: scannedText.text),
                                      );
                                      Fluttertoast.showToast(
                                        msg: 'Se copió al portapapeles',
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                _actionButton(
                                  label: 'Limpiar',
                                  width: 100,
                                  onPressed: () {
                                    setState(() {
                                      scannedText.clear();
                                      imageFile = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
