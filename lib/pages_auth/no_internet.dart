import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text('Reintentar'))
          ],
        ),
      ),
    );
  }
}
