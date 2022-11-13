import 'package:flutter/material.dart';
import 'package:fluttersupabase/pages_auth/login_page.dart';
import 'package:fluttersupabase/pages_auth/splash_page.dart';
import 'package:fluttersupabase/pages_user_main/user_read_pdf.dart';
import 'package:fluttersupabase/pages_user_main/user_speech_to_text.dart';
import 'package:fluttersupabase/pages_user_main/user_image_text.dart';
import 'package:fluttersupabase/pages_user_main/user_new_note.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr_android.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr_ios.dart';
import 'package:fluttersupabase/pages_user_main/user_text_to_speech.dart';
import 'package:fluttersupabase/pages_user_main/user_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

readPDF(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReadPDF(),
      ));
}

speechToText(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeechToTextPage(),
      ));
}

textToSpeech(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextToSpeechPage(),
      ));
}

newNote(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewNote(),
      ));
}

scannerQRIOS(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReadQRIOS(),
      ));
}

translate(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Translate(),
      ));
}

scannerQRANDROID(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReadQRANDROID(),
      ));
}

textImage(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TextImage(),
      ));
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
      ? LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.grey.shade500,
          Colors.grey.shade900,
        ])
      : LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.blue.shade300,
          Colors.green,
        ]);
}

Gradient barColor() {
  return theme
      ? LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.black12,
          Colors.grey.shade300,
        ])
      : LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
          Colors.green,
          Colors.blue.shade300,
        ]);
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

signOut(BuildContext context) {
  try {
    supabase.auth.signOut();
  } on AuthException catch (error) {
    Fluttertoast.showToast(msg: 'Algo salió mal');
  } catch (error) {
    Fluttertoast.showToast(msg: 'Algo salió mal');
  }
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SplashPage(),
      ),
      (route) => false);
}

//dialogo que ocupa toda la ventana
showLoaderDialog(BuildContext context, String message, String ruteLottie) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    content: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.grey.withOpacity(0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    Lottie.asset(
                      ruteLottie,
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
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
