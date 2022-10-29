import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      margin: const EdgeInsets.all(50.0),
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

