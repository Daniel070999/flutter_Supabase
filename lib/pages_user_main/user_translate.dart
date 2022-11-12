import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  'ruso',
  'húngaro',
  'tailandés',
  'noruego',
  'turco',
  'estonio',
  'vietnamita',
  'sueco',
  'árabe',
  'griego',
  'hindi (o hindú)',
  'finlandés',
  'camboyano',
  'ucraniano',
  'letón',
  'honlandés',
  'checo',
  'polaco',
  'eslovaco',
  'búlgaro',
  'indonesio'
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
        color: colorContainer(),
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
            hint: const Text(
              'Seleccione un idioma',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
      } else if (languajeSelected.contains('húngaro')) {
        toValue = 'hu';
      } else if (languajeSelected.contains('tailandés')) {
        toValue = 'th';
      } else if (languajeSelected.contains('noruego')) {
        toValue = 'no';
      } else if (languajeSelected.contains('turco')) {
        toValue = 'tr';
      } else if (languajeSelected.contains('estonio')) {
        toValue = 'et';
      } else if (languajeSelected.contains('vietnamita')) {
        toValue = 'vi';
      } else if (languajeSelected.contains('sueco')) {
        toValue = 'sv';
      } else if (languajeSelected.contains('árabe')) {
        toValue = 'ar';
      } else if (languajeSelected.contains('griego')) {
        toValue = 'el';
      } else if (languajeSelected.contains('hindi (o hindú)')) {
        toValue = 'hi';
      } else if (languajeSelected.contains('finlandés')) {
        toValue = 'fi';
      } else if (languajeSelected.contains('camboyano')) {
        toValue = 'km';
      } else if (languajeSelected.contains('ucraniano')) {
        toValue = 'uk';
      } else if (languajeSelected.contains('letón')) {
        toValue = 'lv';
      } else if (languajeSelected.contains('honlandés')) {
        toValue = 'nl';
      } else if (languajeSelected.contains('checo')) {
        toValue = 'cs';
      } else if (languajeSelected.contains('polaco')) {
        toValue = 'pl';
      } else if (languajeSelected.contains('eslovaco')) {
        toValue = 'sk';
      } else if (languajeSelected.contains('búlgaro')) {
        toValue = 'bg';
      } else if (languajeSelected.contains('indonesio')) {
        toValue = 'id';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Traductor',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
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
                          color: colorContainer(),
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
                          color: colorContainer(),
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
                                      if (_textOutput.text.isNotEmpty) {
                                        Navigator.pushNamed(
                                            context, '/textToSpeech',
                                            arguments: _textOutput.text);
                                      }
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Escuchar',
                                        style:
                                            TextStyle(color: Colors.lightBlue),
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
                                        style:
                                            TextStyle(color: Colors.lightBlue),
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
                                      if (_textOutput.text.isNotEmpty) {
                                        Clipboard.setData(ClipboardData(
                                            text: _textOutput.text));
                                        Fluttertoast.showToast(
                                            msg: 'Se copió al portapepeles',
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.lightGreen);
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
                                        _textOutput.clear();
                                        //se revarga toda la página para evitar problemas con los parámetros
                                        //que son traidos desde la ventana TRANSLATE
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
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
      ),
    );
  }
}
