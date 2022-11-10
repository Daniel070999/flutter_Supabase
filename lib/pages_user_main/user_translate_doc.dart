import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttersupabase/constants.dart';

import 'package:pdf_text/pdf_text.dart';

class TranslateDoc extends StatefulWidget {
  const TranslateDoc({super.key});

  @override
  State<TranslateDoc> createState() => _TranslateDocState();
}

class _TranslateDocState extends State<TranslateDoc> {
  PDFDoc? _pdfDoc;
  String _text = "";
  final _textPDF = TextEditingController();

  bool _buttonsEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Traducir documento',
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
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              TextButton(
                child: Text(
                  "Pick PDF document",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    backgroundColor: Colors.blueAccent),
                onPressed: _pickPDFText,
              ),
              TextButton(
                child: Text(
                  "Read whole document",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    backgroundColor: Colors.blueAccent),
                onPressed: _buttonsEnabled ? _readWholeDoc : () {},
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    maxLines: 20,
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.black),
                    controller: _textPDF,
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
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  /// Picks a new PDF document from the device
  Future _pickPDFText() async {
    try {
      var filePickerResult = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (filePickerResult != null) {
        _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
        setState(() {});
      }
    } catch (e) {
      context.showSnackBar(
          message: 'Intenta con otro documento',
          backgroundColor: Colors.red,
          icon: Icons.warning_amber_rounded);
    }
  }

  Future _readWholeDoc() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text = await _pdfDoc!.text;

    setState(() {
      _text = text;
      _textPDF.text = text;
      _buttonsEnabled = true;
    });
  }
}
