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
  Widget _toolCard({
    required String title,
    required String lottieAsset,
    required VoidCallback onTap,
    BoxFit? fit,
    EdgeInsetsGeometry assetPadding = EdgeInsets.zero,
  }) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 250,
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
          onTap: onTap,
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
                    padding: assetPadding,
                    child: Lottie.asset(
                      lottieAsset,
                      repeat: animationState,
                      fit: fit,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonGroupUp() {
    return Row(
      children: <Widget>[
        _toolCard(
          title: 'LISTA DE NOTAS',
          lottieAsset: 'images/lottie/notes.zip',
          onTap: () => newNote(context),
        ),
        _toolCard(
          title: 'LECTOR DE CÓDIGO QR Y CÓDIGO DE BARRAS',
          lottieAsset: 'images/lottie/qr.zip',
          onTap: () {
            Platform.isAndroid
                ? scannerQRANDROID(context)
                : scannerQRIOS(context);
          },
        ),
      ],
    );
  }

  Widget _buttonGroupDown() {
    return Row(
      children: <Widget>[
        _toolCard(
          title: 'TRADUCTOR DE TEXTO',
          lottieAsset: 'images/lottie/translate.zip',
          onTap: () => translate(context),
        ),
        _toolCard(
          title: 'TEXTO EN IMAGEN',
          lottieAsset: 'images/lottie/imagetext.zip',
          onTap: () => textImage(context),
        ),
      ],
    );
  }

  Widget _buttonGroupDown2() {
    return Row(
      children: <Widget>[
        _toolCard(
          title: 'VOZ A TEXTO',
          lottieAsset: 'images/lottie/microphone.zip',
          onTap: () => speechToText(context),
        ),
        _toolCard(
          title: 'TEXTO A VOZ',
          lottieAsset: 'images/lottie/speaker.zip',
          fit: BoxFit.contain,
          onTap: () => textToSpeech(context),
        ),
      ],
    );
  }

  Widget _buttonGroupDown3() {
    return Row(
      children: <Widget>[
        _toolCard(
          title: 'ABRIR PDF',
          lottieAsset: 'images/lottie/pdf.zip',
          fit: BoxFit.cover,
          assetPadding: const EdgeInsets.all(10.0),
          onTap: () => readPDF(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeSelect(),
      child: Container(
        color: Colors.grey.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              _buttonGroupUp(),
              _buttonGroupDown(),
              _buttonGroupDown2(),
              _buttonGroupDown3(),
            ],
          ),
        ),
      ),
    );
  }
}
