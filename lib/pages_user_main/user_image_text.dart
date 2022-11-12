import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/pages_user_main/user_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextImage extends StatefulWidget {
  const TextImage({Key? key}) : super(key: key);

  @override
  State<TextImage> createState() => _TextImageState();
}

class _TextImageState extends State<TextImage> {
  bool textScanning = false;

  XFile? imageFile;

  final scannedText = TextEditingController();

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText.text = "Ocurrio un error durante el reconocimiento";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText.clear();
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        setState(() {
          scannedText.text = scannedText.text + line.text + "\n";
        });
      }
    }
    textScanning = false;
    setState(() {});
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/camera.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text("Cámara"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/galleryPicture.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Seleccionar una imagen",
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Texto en imagen',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withOpacity(0.2),
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
                  padding:
                      const EdgeInsets.only(right: 30.0, left: 30.0, top: 10.0),
                  child: _buttonGroupDownTextImage(),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (imageFile != null)
                  Image.file(
                    File(imageFile!.path),
                    width: 300,
                    height: 300,
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (!textScanning && imageFile == null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.grey.shade400),
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
                        color: colorContainer()),
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
                              labelText: "Texto reconocido",
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
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromWidth(150)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  foregroundColor: MaterialStateProperty.all(
                                      Colors.lightBlue),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Colors.lightBlue)),
                                ),
                                onPressed: () {
                                  if (scannedText.text.isNotEmpty) {
                                    Navigator.pushNamed(
                                        context, '/textToSpeech',
                                        arguments: scannedText.text);
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    'Escuchar',
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromWidth(150)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  foregroundColor: MaterialStateProperty.all(
                                      Colors.lightBlue),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Colors.lightBlue)),
                                ),
                                onPressed: () {
                                  if (scannedText.text.isNotEmpty) {
                                    Navigator.pushNamed(context, '/translate',
                                        arguments: scannedText.text);
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    'Traducir',
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromWidth(100)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  foregroundColor: MaterialStateProperty.all(
                                      Colors.lightBlue),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Colors.lightBlue)),
                                ),
                                onPressed: () {
                                  if (scannedText.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'No hay nada para copiar');
                                  } else {
                                    Clipboard.setData(
                                        ClipboardData(text: scannedText.text));

                                    Fluttertoast.showToast(
                                        msg: 'Se copió al portapapeles');
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    'Copiar',
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromWidth(100)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  foregroundColor: MaterialStateProperty.all(
                                      Colors.lightBlue),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Colors.lightBlue)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    scannedText.clear();
                                    imageFile = null;
                                  });
                                },
                                child: const Center(
                                  child: Text(
                                    'Limpiar',
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                ),
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
          )),
        ),
      ),
    );
  }
}
