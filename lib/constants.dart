import 'package:flutter/material.dart';
import 'package:fluttersupabase/pages_user_main/user_image_text.dart';
import 'package:fluttersupabase/pages_user_main/user_new_note.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr_android.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr_ios.dart';
import 'package:fluttersupabase/pages_user_main/user_translate.dart';
import 'package:fluttersupabase/pages_user_main/user_translate_doc.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

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
translateDoc(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TranslateDoc(),
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
          builder: (context) => TextImage(),
        ));
  }
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
            Icon(
              icon,
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

bool animationState = true;

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
