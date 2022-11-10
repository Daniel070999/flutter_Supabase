import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:lottie/lottie.dart';

class ContainerUserMain extends StatefulWidget {
  const ContainerUserMain({super.key});

  @override
  State<ContainerUserMain> createState() => _ContainerUserMainState();
}

class _ContainerUserMainState extends State<ContainerUserMain> {
  


  Widget _buttonGroupUp() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 300,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                newNote(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/notes.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("LISTA DE NOTAS")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 300,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                Platform.isAndroid
                    ? scannerQRANDROID(context)
                    : scannerQRIOS(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/qr.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "LECTOR DE CÓDIGO QR Y CÓDIGO DE BARRAS",
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
            height: 300,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                translate(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/translate.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(flex: 1, child: Text("TRADUCTOR DE TEXTO")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 300,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                textImage(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Lottie.asset(
                        'images/lottie/imagetext.zip',
                        repeat: animationState,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "TEXTO EN IMAGEN",
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.grey.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                _buttonGroupUp(),
                _buttonGroupDown(),
              ],
            ),
          )),
    );
  }
}
