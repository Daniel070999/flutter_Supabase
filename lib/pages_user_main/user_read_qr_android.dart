import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:share_plus/share_plus.dart';

class ReadQRANDROID extends StatefulWidget {
  const ReadQRANDROID({super.key});

  @override
  State<ReadQRANDROID> createState() => _ReadQRANDROIDState();
}

class _ReadQRANDROIDState extends State<ReadQRANDROID>
    with TickerProviderStateMixin {
  Uint8List bytes = Uint8List(0);
  late TextEditingController _inputController;
  late TextEditingController _outputController;

  @override
  initState() {
    super.initState();
    _inputController = TextEditingController();
    _outputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Códigos QR y Códigos de barras',
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
              Colors.green,
              Colors.blue.shade300,
            ]),
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        child: Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 50.0, left: 50.0, top: 50),
                      child: _buttonGroupUp(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            maxLines: 3,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(color: Colors.black),
                            controller: _outputController,
                            decoration: InputDecoration(
                              labelText: "Texto escaneado",
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
                                  _outputController.clear();
                                },
                                child: const Center(
                                    child: Text(
                                  'Limpiar',
                                  style: TextStyle(color: Colors.lightBlue),
                                )),
                              ),
                              const SizedBox(
                                width: 20,
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
                                  if (_outputController.text.isEmpty) {
                                    context.showSnackBar(
                                        message:
                                            'No hay información para compartir',
                                        backgroundColor: Colors.amber,
                                        icon: Icons.warning_amber_rounded);
                                  } else {
                                    Share.share(_outputController.text);
                                  }
                                },
                                child: const Center(
                                    child: Text(
                                  'Compartir',
                                  style: TextStyle(color: Colors.lightBlue),
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0, left: 50.0),
                      child: Column(
                        children: const [
                          Text(
                            '¿Desea crear un código QR?',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Ingrese información en el siguiente cuadro de texto y luego genere el código',
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Este campo no puede estar vacío';
                          }
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
                          labelText: "Texto para convertir a código QR",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 125.0, left: 125.0, top: 20.0),
                      child: _buttonGroupDown(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 250,
                child: bytes.isEmpty
                    ? const Text(
                        'Sin código',
                      )
                    : Image.memory(bytes),
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
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightGreen),
                            overlayColor: MaterialStateProperty.all(
                                Colors.lightGreen.shade200),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await ImageGallerySaver.saveImage(this.bytes);
                              if (mounted) {
                                context.showSnackBar(
                                    message: 'Se guardo en galeria',
                                    backgroundColor: Colors.lightGreen,
                                    icon: Icons.check_circle_outline_outlined);
                                Navigator.pop(context);
                                _inputController.clear();
                              }
                            } catch (e) {
                              context.showSnackBar(
                                  message: 'No se pudo guardar la imagen',
                                  backgroundColor: Colors.red,
                                  icon: Icons.warning);
                            }
                          },
                          child: const Center(
                              child: Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                            overlayColor: MaterialStateProperty.all(
                                Colors.lightGreen.shade200),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              this.bytes = Uint8List(0);
                              Navigator.pop(context);
                              _inputController.clear();
                            });
                          },
                          child: const Center(
                              child: Text(
                            '    Salir    ',
                            style: TextStyle(color: Colors.white),
                          )),
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset('images/scanPhone.png'),
                    ),
                    const Expanded(flex: 1, child: Text("Escanear")),
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
              onTap: _scanPhoto,
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('images/createQR.png'),
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("Generar QR")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('No se escaneo.');
    } else {
      _outputController.text = barcode;
    }
  }

  Future _scanPhoto() async {
    await Permission.storage.request();
    String barcode = await scanner.scanPhoto();
    _outputController.text = barcode;
  }

  Future _generateBarCode(String inputCode, BuildContext context) async {
    if (inputCode.isEmpty) {
      context.showSnackBar(
          message: 'Primero debe ingresar un texto',
          backgroundColor: Colors.red,
          icon: Icons.warning);
    } else {
      Uint8List result = await scanner.generateBarCode(inputCode);
      setState(() {
        bytes = result;
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            transitionAnimationController: AnimationController(
                vsync: this, duration: const Duration(milliseconds: 400)),
            builder: (BuildContext context) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    )),
                padding: const EdgeInsets.all(30.0),
                height: 500,
                child: _qrCodeWidget(bytes, context),
              );
            });
      });
    }
  }
}
