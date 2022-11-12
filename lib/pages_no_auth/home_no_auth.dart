import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';

class UserNoAuth extends StatefulWidget {
  const UserNoAuth({super.key});

  @override
  State<UserNoAuth> createState() => _UserNoAuthState();
}

class _UserNoAuthState extends State<UserNoAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Menu principal',
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withOpacity(0.2),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: null,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white.withOpacity(0.5)),
                        height: 100,
                        child: Row(
                          children: [
                            const Image(
                              image: AssetImage('images/notes.png'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'LISTA DE NOTAS',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.grey),
                                ),
                                Text(
                                  '(Disponible solo iniciando sesión)',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: () {
                        if (Platform.isAndroid) {
                          scannerQRANDROID(context);
                        } else {
                          scannerQRIOS(context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white),
                        height: 100,
                        child: Row(
                          children: const [
                            Image(
                              image: AssetImage('images/qr.png'),
                            ),
                            Text(
                              'LECTOR DE CÓDIGO QR\nY CÓDIGO DE BARRAS',
                              style: TextStyle(fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: () {
                        translate(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white),
                        height: 100,
                        child: Row(
                          children: const [
                            Image(
                              image: AssetImage('images/translate.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'TRADUCTOR DE TEXTO',
                              style: TextStyle(fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: () {
                        textImage(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white),
                        height: 100,
                        child: Row(
                          children: const [
                            Image(
                              image: AssetImage('images/capturetext.png'),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'TEXTO EN IMAGEN',
                              style: TextStyle(fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: null,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white.withOpacity(0.5)),
                        height: 100,
                        child: Row(
                          children: [
                            const Image(
                              image: AssetImage('images/recording.png'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'VOZ A TEXTO',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.grey),
                                ),
                                Text(
                                  '(Disponible solo iniciando sesión)',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: () {
                        textToSpeech(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white),
                        height: 100,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Image(
                                image: AssetImage('images/speaker.png'),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'TEXTO A VOZ',
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: () {
                        readPDF(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white),
                        height: 100,
                        child: Row(
                          children: const [
                            Image(
                              image: AssetImage('images/pdf.png'),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'ABRIR PDF',
                              style: TextStyle(fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
