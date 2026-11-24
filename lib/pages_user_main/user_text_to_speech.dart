import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttersupabase/constants.dart';

class TextToSpeechPage extends StatefulWidget {
  const TextToSpeechPage({super.key});

  @override
  State<TextToSpeechPage> createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  final String defaultLanguage = 'en-US';
  final FlutterTts tts = FlutterTts();

  String text = '';
  double volume = 1.0;
  double rate = 0.5;
  double pitch = 1.0;

  String? languageCode;
  List<String> languageCodes = <String>[];
  bool _loadedRouteArgs = false;

  final textEditingControllerTS = TextEditingController();
  final listDownController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingControllerTS.text = text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedRouteArgs) return;
    _loadedRouteArgs = true;
    final Object? parametros = ModalRoute.of(context)?.settings.arguments;
    if (parametros != null) {
      text = parametros.toString();
      textEditingControllerTS.text = text;
    }
  }

  @override
  void dispose() {
    tts.stop();
    textEditingControllerTS.dispose();
    listDownController.dispose();
    super.dispose();
  }

  Future<void> initLanguages() async {
    try {
      final dynamic rawLanguages = await tts.getLanguages;
      if (rawLanguages is List) {
        languageCodes = rawLanguages
            .map((e) => e.toString())
            .toSet()
            .toList()
          ..sort();
      }
      if (languageCodes.contains(defaultLanguage)) {
        languageCode = defaultLanguage;
      } else if (languageCodes.isNotEmpty) {
        languageCode = languageCodes.first;
      }
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      // Ignorado si el motor TTS no está disponible en el entorno actual.
    }
  }

  Widget _buttonGroupOptions() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: speak,
              child: Card(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        'images/speaker.png',
                        scale: 9.0,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text('Escuchar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                tts.stop();
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
                      child: Image.asset(
                        'images/stop.png',
                        scale: 7.0,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Detener',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 150,
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                setState(() {
                  text = '';
                  textEditingControllerTS.clear();
                });
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
                      child: Image.asset('images/sweep.png'),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Limpiar',
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

  Widget _listDown(BuildContext context) {
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
              'Seleccione un acento',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            items: languageCodes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            }).toList(),
            value: languageCode,
            onChanged: (String? newValue) {
              setState(() {
                languageCode = newValue;
              });
            },
            dropdownSearchData: DropdownSearchData<String>(
              searchController: listDownController,
              searchInnerWidgetHeight: 56,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: listDownController,
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
                listDownController.clear();
              }
            },
          ),
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
          title: const Text('Texto a voz'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: barColor(),
            ),
          ),
        ),
        body: Container(
          color: Colors.grey.withValues(alpha: 0.2),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: colorContainer(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              onChanged: (String newText) {
                                setState(() {
                                  text = newText;
                                });
                              },
                              maxLines: 15,
                              cursorColor: Colors.blue,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: Colors.black),
                              controller: textEditingControllerTS,
                              decoration: InputDecoration(
                                labelText: 'Ingrese un texto',
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
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _listDown(context),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buttonGroupOptions(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get supportPause => defaultTargetPlatform != TargetPlatform.android;

  bool get supportResume => defaultTargetPlatform != TargetPlatform.android;

  Future<void> speak() async {
    await tts.setVolume(volume);
    await tts.setSpeechRate(rate);
    if (languageCode != null) {
      await tts.setLanguage(languageCode!);
    }
    await tts.setPitch(pitch);
    await tts.speak(text);
  }
}
