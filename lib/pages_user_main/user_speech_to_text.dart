import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  bool isListening = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  final lastWords = TextEditingController();
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  final SpeechToText speech = SpeechToText();
  final Codec<String, String> _stringToBase64 = utf8.fuse(base64);

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  @override
  void dispose() {
    speech.cancel();
    lastWords.dispose();
    super.dispose();
  }

  Future<void> initSpeechState() async {
    try {
      final hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
      );
      if (hasSpeech) {
        final systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        lastError = 'Reconocimiento fallido : $e';
      });
    }
  }

  Future<void> _saveNote(BuildContext context) async {
    Fluttertoast.showToast(
      msg: 'Guardando nota...',
      gravity: ToastGravity.CENTER,
    );
    try {
      final title = _stringToBase64.encode('Voz a Texto');
      final description = _stringToBase64.encode(lastWords.text);
      final createAt = DateTime.now().toIso8601String();
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = {
        'id_notes_user': userId,
        'create_at': createAt,
        'title': title,
        'description': description,
      };
      await supabase.from('notes').insert(data);
      if (mounted) {
        Fluttertoast.showToast(msg: 'Nota guardada');
      }
    } catch (e) {
      if (isNetworkError(e)) {
        Fluttertoast.showToast(
          msg: 'Revise su conexión a Internet',
          backgroundColor: Colors.red,
        );
      } else {
        Fluttertoast.showToast(msg: 'Algo salió mal');
      }
    }
    if (mounted) {
      setState(() {
        lastWords.clear();
      });
    }
  }

  Widget _optionCard({
    required String imageAsset,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 150,
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
                  child: Image.asset(imageAsset),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    label,
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

  Widget _buttonGroupOptions() {
    return Row(
      children: <Widget>[
        _optionCard(
          imageAsset: 'images/notes.png',
          label: 'Guardar como nota',
          onTap: () {
            if (lastWords.text.isEmpty) {
              Fluttertoast.showToast(msg: 'No hay nada para guardar');
            } else {
              _saveNote(context);
            }
          },
        ),
        const SizedBox(width: 10.0),
        _optionCard(
          imageAsset: 'images/translate.png',
          label: 'Traducir',
          onTap: () {
            if (lastWords.text.isEmpty) {
              Fluttertoast.showToast(msg: 'No hay nada para traducir');
            } else {
              Navigator.pushNamed(
                context,
                '/translate',
                arguments: lastWords.text,
              );
            }
          },
        ),
        const SizedBox(width: 10.0),
        _optionCard(
          imageAsset: 'images/sweep.png',
          label: 'Limpiar',
          onTap: () {
            setState(() {
              lastWords.clear();
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeSelect(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voz a texto'),
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
                                maxLines: 15,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(color: Colors.black),
                                controller: lastWords,
                                decoration: InputDecoration(
                                  labelText: 'Texto Reconocido',
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
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                      child: _buttonGroupOptions(),
                    ),
                    GestureDetector(
                      onTap: isListening ? null : startListening,
                      child: Center(
                        child: speech.isListening
                            ? Lottie.asset(
                                'images/lottie/recording.zip',
                                animate: true,
                                width: 300,
                                height: 200,
                              )
                            : Lottie.asset(
                                'images/lottie/recording.zip',
                                animate: false,
                                width: 300,
                                height: 200,
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

  void startListening() {
    setState(() {
      isListening = true;
    });
    lastWords.clear();
    lastError = '';
    speech.listen(
      onResult: resultListener,
      onSoundLevelChange: soundLevelListener,
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: _currentLocaleId.isEmpty ? null : _currentLocaleId,
        listenMode: ListenMode.confirmation,
      ),
    );
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() {
      lastWords.text = result.recognizedWords;
      isListening = false;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    if (!mounted) return;
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    if (!mounted) return;
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
      isListening = false;
    });
  }

  void statusListener(String status) {
    if (!mounted) return;
    setState(() {
      lastStatus = status;
    });
  }
}
