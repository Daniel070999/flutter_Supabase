import 'package:flutter/material.dart';
import 'package:fluttersupabase/pages_auth/account_page.dart';
import 'package:fluttersupabase/pages_auth/login_page.dart';
import 'package:fluttersupabase/pages_auth/resetPassword_page.dart';
import 'package:fluttersupabase/pages_auth/splash_page.dart';
import 'package:fluttersupabase/pages_user_main/user_main.dart';
import 'package:fluttersupabase/pages_user_main/user_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ergjvwwsxxowhfbktrnj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyZ2p2d3dzeHhvd2hmYmt0cm5qIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjYzNjc2NDIsImV4cCI6MTk4MTk0MzY0Mn0.xcCludLuJeTCkH3rsrGy3YvHp1_a6L3zNKRjkToFd1Q',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      title: 'minimizado',
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme(),
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
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/reset': (_) => const ResetPassword(),
        '/userMain': (_) => UserMain(),
      },
    );
  }
}
