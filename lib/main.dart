import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/forms/drawer_screen.dart';
import 'package:fluttersupabase/pages_auth/account_page.dart';
import 'package:fluttersupabase/pages_auth/login_page.dart';
import 'package:fluttersupabase/pages_auth/no_internet.dart';
import 'package:fluttersupabase/pages_auth/resetPassword_page.dart';
import 'package:fluttersupabase/pages_auth/splash_page.dart';
import 'package:fluttersupabase/pages_user_main/user_main.dart';
import 'package:fluttersupabase/pages_user_main/user_profile.dart';
import 'package:fluttersupabase/pages_user_main/user_text_to_speech.dart';
import 'package:fluttersupabase/pages_user_main/user_translate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError(
      'Faltan credenciales de Supabase. Ejecuta con '
      '--dart-define-from-file=.env o pasa '
      '--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
    );
  }
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'Herramientas de texto',
      theme: themeSelect(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/reset': (_) => const ResetPassword(),
        '/userMain': (_) => const UserMain(),
        '/noInternet': (_) => const NoInternet(),
        '/translate': (_) => const Translate(),
        '/textToSpeech': (_) => const TextToSpeechPage(),
        '/drawer': (_) => const DrawerScreen(),
        '/userProfile': (_) => const UserProfileUpdate(),
      },
    );
  }
}
