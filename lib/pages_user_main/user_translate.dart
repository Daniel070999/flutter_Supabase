import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

class Translate extends StatefulWidget {
  const Translate({super.key});

  @override
  State<Translate> createState() => _TranslateState();
}

const Map<String, String> _languageCodeMap = {
  'español': 'es',
  'ingles': 'en',
  'portugués': 'pt',
  'francés': 'fr',
  'italiano': 'it',
  'chino': 'zh-cn',
  'coreano': 'ko',
  'japonés': 'ja',
  'alemán': 'de',
  'ruso': 'ru',
  'húngaro': 'hu',
  'tailandés': 'th',
  'noruego': 'no',
  'turco': 'tr',
  'estonio': 'et',
  'vietnamita': 'vi',
  'sueco': 'sv',
  'árabe': 'ar',
  'griego': 'el',
  'hindi (o hindú)': 'hi',
  'finlandés': 'fi',
  'camboyano': 'km',
  'ucraniano': 'uk',
  'letón': 'lv',
  'honlandés': 'nl',
  'checo': 'cs',
  'polaco': 'pl',
  'eslovaco': 'sk',
  'búlgaro': 'bg',
  'indonesio': 'id',
};

class _TranslateState extends State<Translate> {
  final _textInput = TextEditingController();
  final _textOutput = TextEditingController();
  final _searchController = TextEditingController();
  String? _selectedValue;
  String _languageSelected = 'español';
  bool _loadedRouteArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedRouteArgs) return;
    _loadedRouteArgs = true;
    final Object? parametros = ModalRoute.of(context)?.settings.arguments;
    if (parametros != null) {
      _textInput.text = parametros.toString();
    }
  }

  @override
  void dispose() {
    _textInput.dispose();
    _textOutput.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _listItemsLanguage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: colorContainer(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_double_arrow_down_rounded,
                color: Colors.lightBlue,
              ),
            ),
            barrierColor: Colors.grey.withValues(alpha: 0.7),
            buttonStyleData: const ButtonStyleData(
              height: 40,
              padding: EdgeInsets.all(10.0),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 250,
            ),
            hint: const Text(
              'Seleccione un idioma',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            items: _languageCodeMap.keys
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
                .toList(),
            value: _selectedValue,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedValue = value;
                _languageSelected = value;
                _textOutput.text = 'Traduciendo...';
              });
              _translate(_textInput.text);
            },
            dropdownSearchData: DropdownSearchData<String>(
              searchController: _searchController,
              searchInnerWidgetHeight: 56,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
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
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _translate(String valueIn) async {
    final translator = GoogleTranslator();
    final String toValue = _languageCodeMap[_languageSelected] ?? 'es';
    try {
      final valueOut = await translator.translate(valueIn, to: toValue);
      if (mounted) {
        _textOutput.text = valueOut.text;
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      if (msg.contains('Broken')) {
        _textOutput.text = 'Intenta con un texto mas corto';
      } else if (msg.contains('Failed') || isNetworkError(e)) {
        _textOutput.text = 'No hay conexión a internet';
      } else {
        _textOutput.clear();
      }
    }
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
          title: const Text('Traductor'),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withValues(alpha: 0.2),
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
                                  labelText: 'Ingrese el texto a traducir',
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
                    _listItemsLanguage(context),
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
                                maxLines: 10,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(color: Colors.black),
                                readOnly: true,
                                controller: _textOutput,
                                decoration: InputDecoration(
                                  labelText: 'Texto traducido',
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
                                    label: 'Escuchar',
                                    width: 150,
                                    onPressed: () {
                                      if (_textOutput.text.isNotEmpty) {
                                        Navigator.pushNamed(
                                          context,
                                          '/textToSpeech',
                                          arguments: _textOutput.text,
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  _actionButton(
                                    label: 'Compartir',
                                    width: 150,
                                    onPressed: () {
                                      if (_textOutput.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: 'No hay nada para copiar',
                                        );
                                      } else {
                                        Share.share(_textOutput.text);
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
                                      if (_textOutput.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: 'No hay nada para copiar',
                                        );
                                      } else {
                                        Clipboard.setData(
                                          ClipboardData(text: _textOutput.text),
                                        );
                                        Fluttertoast.showToast(
                                          msg: 'Se copió al portapapeles',
                                          toastLength: Toast.LENGTH_SHORT,
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
                                        _textInput.clear();
                                        _textOutput.clear();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
