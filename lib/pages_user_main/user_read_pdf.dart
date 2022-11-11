import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:fluttersupabase/constants.dart';

class ReadPDF extends StatefulWidget {
  const ReadPDF({super.key});

  @override
  State<ReadPDF> createState() => _ReadPDFState();
}

class _ReadPDFState extends State<ReadPDF> {
  final _textInput = TextEditingController();
  PDFDoc? _pdfDoc;

  Future _pickPDFText(BuildContext context) async {
    try {
      var filePickerResult = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

      if (filePickerResult != null) {
        _textInput.text = 'Cargando PDF...';
        _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);

        setState(() {});
      }
      if (_pdfDoc == null) {
        return;
      }
      String text = await _pdfDoc!.text;

      setState(() {
        _textInput.text = text;
      });
    } catch (e) {
      context.showSnackBar(
          message: 'Intenta con otro documento',
          backgroundColor: Colors.red,
          icon: Icons.warning_amber_rounded);
    }
  }

  Widget _buttonPickPDF() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                _pickPDFText(context);
              },
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/pdf.png'),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text("Seleccionar PDF"),
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
        appBar: AppBar(
          title: const Text(
            'Abrir PDF',
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
            child: Center(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 80.0, left: 80.0, top: 10.0),
                        child: _buttonPickPDF(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLines: 25,
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(color: Colors.black),
                                  controller: _textInput,
                                  decoration: InputDecoration(
                                    labelText: "Texto de PDF",
                                    labelStyle:
                                        const TextStyle(color: Colors.blue),
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
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        foregroundColor:
                                            MaterialStateProperty.all(
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
                                        if (_textInput.text.isNotEmpty) {
                                          Navigator.pushNamed(
                                              context, '/textToSpeech',
                                              arguments: _textInput.text);
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Escuchar',
                                          style: TextStyle(
                                              color: Colors.lightBlue),
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
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        foregroundColor:
                                            MaterialStateProperty.all(
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
                                        if (_textInput.text.isNotEmpty) {
                                          Navigator.pushNamed(
                                              context, '/translate',
                                              arguments: _textInput.text);
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Traducir',
                                          style: TextStyle(
                                              color: Colors.lightBlue),
                                        ),
                                      ),
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
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        foregroundColor:
                                            MaterialStateProperty.all(
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
                                        if (_textInput.text.isNotEmpty) {
                                          Clipboard.setData(ClipboardData(
                                              text: _textInput.text));
                                          context.showSnackBar(
                                              message: 'Texto copiado',
                                              backgroundColor:
                                                  Colors.lightGreen,
                                              icon: Icons
                                                  .check_circle_outline_rounded);
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Copiar',
                                          style: TextStyle(
                                              color: Colors.lightBlue),
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
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        foregroundColor:
                                            MaterialStateProperty.all(
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
                                          _textInput.clear();
                                        });
                                      },
                                      child: const Center(
                                          child: Text(
                                        'Limpiar',
                                        style:
                                            TextStyle(color: Colors.lightBlue),
                                      )),
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
                ],
              ),
            )));
  }
}
