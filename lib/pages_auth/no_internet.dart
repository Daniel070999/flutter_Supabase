import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/pages_no_auth/home_no_auth.dart';
import 'package:lottie/lottie.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('images/lottie/nointernet.zip',
                  repeat: true, height: 200, width: 200, fit: BoxFit.contain),
              const SizedBox(
                height: 20,
              ),
              const Text('Sin conexión'),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text('Reintentar')),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserNoAuth(),
                        ));
                  },
                  child: const Text(
                      'Usar sin internet\n(Se limitarán ciertas funciones)',
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }
}
