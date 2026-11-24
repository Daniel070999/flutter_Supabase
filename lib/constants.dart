import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/acerca.dart';
import 'package:fluttersupabase/pages_auth/splash_page.dart';
import 'package:fluttersupabase/pages_user_main/user_image_text.dart';
import 'package:fluttersupabase/pages_user_main/user_new_note.dart';
import 'package:fluttersupabase/pages_user_main/user_read_pdf.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr_android.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr_ios.dart';
import 'package:fluttersupabase/pages_user_main/user_speech_to_text.dart';
import 'package:fluttersupabase/pages_user_main/user_text_to_speech.dart';
import 'package:fluttersupabase/pages_user_main/user_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: '',
);

const String supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: '',
);

const String supportEmail = String.fromEnvironment(
  'SUPPORT_EMAIL',
  defaultValue: 'soporte@ejemplo.com',
);

const String storeUrl = String.fromEnvironment(
  'STORE_URL',
  defaultValue: '',
);

const String loginRedirectUrl = String.fromEnvironment(
  'LOGIN_REDIRECT_URL',
  defaultValue: 'com.herramientasdetexto.app://login-callback/',
);

const String resetRedirectUrl = String.fromEnvironment(
  'RESET_REDIRECT_URL',
  defaultValue: 'com.herramientasdetexto.app://reset-callback/',
);

SupabaseClient get supabase => Supabase.instance.client;

bool hasInternetConnection(List<ConnectivityResult> results) {
  return results.any(
    (result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.mobile,
  );
}

bool isNetworkError(Object error) {
  if (error is SocketException) {
    return true;
  }
  final msg = error.toString().toLowerCase();
  return msg.contains('socketexception') ||
      msg.contains('failed host lookup') ||
      msg.contains('clientexception') ||
      msg.contains('connection refused') ||
      msg.contains('connection reset');
}

Future<void> acerca(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AcercaApp(),
    ),
  );
}

Future<void> readPDF(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ReadPDF(),
    ),
  );
}

Future<void> speechToText(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SpeechToTextPage(),
    ),
  );
}

Future<void> textToSpeech(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TextToSpeechPage(),
    ),
  );
}

Future<void> newNote(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const NewNote(),
    ),
  );
}

Future<void> scannerQRIOS(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ReadQRIOS(),
    ),
  );
}

Future<void> translate(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const Translate(),
    ),
  );
}

Future<void> scannerQRANDROID(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ReadQRANDROID(),
    ),
  );
}

Future<void> textImage(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TextImage(),
    ),
  );
}

bool animationState = true;
bool theme = false;

Color menuBackgroundColor() {
  return theme ? Colors.grey.shade900 : Colors.green;
}

Color colorContainer() {
  return theme ? Colors.grey.shade300 : Colors.white;
}

Gradient barColorScreen() {
  return theme
      ? LinearGradient(
          begin: Alignment.centerLeft,
          colors: <Color>[
            Colors.grey.shade500,
            Colors.grey.shade900,
          ],
        )
      : LinearGradient(
          begin: Alignment.centerLeft,
          colors: <Color>[
            Colors.blue.shade300,
            Colors.green,
          ],
        );
}

Gradient barColor() {
  return theme
      ? LinearGradient(
          begin: Alignment.centerLeft,
          colors: <Color>[
            Colors.black12,
            Colors.grey.shade300,
          ],
        )
      : LinearGradient(
          begin: Alignment.centerLeft,
          colors: <Color>[
            Colors.green,
            Colors.blue.shade300,
          ],
        );
}

ThemeData themeSelect() {
  return theme
      ? ThemeData.dark().copyWith(
          textTheme: GoogleFonts.ralewayTextTheme(),
          cardColor: Colors.grey,
          primaryColorDark: Colors.green,
          primaryColor: Colors.green,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        )
      : ThemeData.light().copyWith(
          textTheme: GoogleFonts.ralewayTextTheme(),
          cardColor: Colors.white,
          primaryColorDark: Colors.green,
          primaryColor: Colors.green,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        );
}

Future<void> signOut(BuildContext context) async {
  try {
    await supabase.auth.signOut();
  } on AuthException {
    Fluttertoast.showToast(msg: 'Algo salió mal');
  } catch (_) {
    Fluttertoast.showToast(msg: 'Algo salió mal');
  }
  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => const SplashPage(),
    ),
    (route) => false,
  );
}

// Diálogo modal de carga reutilizable
void showLoaderDialog(
  BuildContext context,
  String message,
  String ruteLottie,
) {
  final alert = AlertDialog(
    backgroundColor: Colors.transparent,
    content: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.grey.withValues(alpha: 0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Lottie.asset(
                        ruteLottie,
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => alert,
  );
}
