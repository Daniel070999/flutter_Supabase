import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';
import 'package:fluttersupabase/constants.dart';

class Translate extends StatefulWidget {
  const Translate({super.key});

  @override
  State<Translate> createState() => _TranslateState();
}

const List<String> items = [
  'español',
  'ingles',
  'portugués',
  'francés',
  'italiano',
  'chino',
  'coreano',
  'japonés',
  'alemán',
  'ruso'
];
String? selectedValue;
final TextEditingController textEditingController = TextEditingController();

class _TranslateState extends State<Translate> {
  final _textInput = TextEditingController();
  final _textOutput = TextEditingController();
  String languajeSelected = 'español';
  PDFDoc? _pdfDoc;
  Widget _listItemsLanguaje(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            icon: const Icon(
              Icons.keyboard_double_arrow_down_rounded,
              color: Colors.lightBlue,
            ),
            barrierColor: Colors.grey.withOpacity(0.7),
            buttonPadding: const EdgeInsets.all(10.0),
            hint: Text(
              'Seleccione un idioma',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value as String;
                languajeSelected = value;
                _textOutput.text = 'Traduciendo...';
                _translate(_textInput.text);
              });
            },
            buttonHeight: 40,
            itemHeight: 40,
            dropdownMaxHeight: 250,
            searchController: textEditingController,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  hintText: 'Buscar un idioma',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return (item.value.toString().contains(searchValue));
            },
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _translate(String valueIn) async {
    final translator = GoogleTranslator();
    String toValue = '';
    try {
      if (languajeSelected.contains('español')) {
        toValue = 'es';
      } else if (languajeSelected.contains('ingles')) {
        toValue = 'en';
      } else if (languajeSelected.contains('portugués')) {
        toValue = 'pt';
      } else if (languajeSelected.contains('francés')) {
        toValue = 'fr';
      } else if (languajeSelected.contains('italiano')) {
        toValue = 'it';
      } else if (languajeSelected.contains('chino')) {
        toValue = 'zh-cn';
      } else if (languajeSelected.contains('coreano')) {
        toValue = 'ko';
      } else if (languajeSelected.contains('japonés')) {
        toValue = 'ja';
      } else if (languajeSelected.contains('alemán')) {
        toValue = 'de';
      } else if (languajeSelected.contains('ruso')) {
        toValue = 'ru';
      }
      await translator.translate(valueIn, to: toValue).then((valueOut) {
        _textOutput.text = valueOut.text;
      });
    } catch (e) {
      print(e);
      if (e.toString().contains('Broken')) {
        _textOutput.text = 'Intenta con un texto mas corto';
      } else {
        _textOutput.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Object? parametros = ModalRoute.of(context)!.settings.arguments;
    if (parametros != null) {
      setState(() {
        _textInput.text = parametros.toString();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Traductor',
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
            shrinkWrap: true,
            children: [
              Column(
                children: [
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
                              onChanged: (value) {
                                setState(() {
                                  _textOutput.text = 'Traduciendo...';
                                });
                                _translate(value);
                              },
                              maxLines: 10,
                              cursorColor: Colors.blue,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: Colors.black),
                              controller: _textInput,
                              decoration: InputDecoration(
                                labelText: "Ingrese el texto a traducir",
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
                              children: [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _listItemsLanguaje(context),
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
                              onChanged: (value) {
                                setState(() {
                                  _textOutput.text = 'Traduciendo...';
                                });
                                _translate(value);
                              },
                              maxLines: 10,
                              cursorColor: Colors.blue,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: Colors.black),
                              readOnly: true,
                              controller: _textOutput,
                              decoration: InputDecoration(
                                labelText: "Texto traducido",
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
                                    if (_textOutput.text.isNotEmpty) {
                                      Navigator.pushNamed(
                                          context, '/textToSpeech',
                                          arguments: _textOutput.text);
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
                                    if (_textOutput.text.isEmpty) {
                                      context.showSnackBar(
                                          message:
                                              'No hay información para compartir',
                                          backgroundColor: Colors.amber,
                                          icon: Icons.warning_amber_rounded);
                                    } else {
                                      Share.share(_textOutput.text);
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Compartir',
                                      style: TextStyle(color: Colors.lightBlue),
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
                                    if (_textOutput.text.isNotEmpty) {
                                      Clipboard.setData(ClipboardData(
                                          text: _textOutput.text));
                                      context.showSnackBar(
                                          message: 'Se copio al portapeles',
                                          backgroundColor: Colors.lightGreen,
                                          icon: Icons
                                              .check_circle_outline_outlined);
                                    }
                                  },
                                  child: const Center(
                                      child: Text(
                                    'Copiar',
                                    style: TextStyle(color: Colors.lightBlue),
                                  )),
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
                                      _textInput.clear();
                                      _textOutput.clear();
                                      //se revarga toda la página para evitar problemas con los parámetros
                                      //que son traidos desde la ventana TRANSLATE
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  super.widget));
                                    });
                                  },
                                  child: const Center(
                                      child: Text(
                                    'Limpiar',
                                    style: TextStyle(color: Colors.lightBlue),
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
        ),
      ),
    );
  }
}
