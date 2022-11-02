import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    required Color backgroundColor,
    required IconData icon, 
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Container(
        height: 50,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(icon,
              size: 25,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              message,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ));
  }
}

extension ShowSnackBarWithButton on BuildContext {
  void showSnackBarWithButtion({
    required String message,
    required Color backgroundColor,
    required String messageButton,
    required void Function() Function,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 100.0, left: 25.0, right: 25.0),
      action: SnackBarAction(
        label: messageButton,
        onPressed: Function,
        textColor: Colors.black,
      ),
      duration: const Duration(minutes: 5),
    ));
  }
}

//dialogo que ocupa toda la ventana
showLoaderDialog(BuildContext context, String message) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        const SizedBox(
          width: 20,
        ),
        Platform.isAndroid
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator()
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
