import 'package:flutter/material.dart';
import 'package:fluttersupabase/pages/account_page.dart';
import 'package:fluttersupabase/pages/login_page.dart';
import 'package:fluttersupabase/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    // TODO: Replace credentials with your own
    url: 'https://ergjvwwsxxowhfbktrnj.supabase.co',
    anonKey:  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVyZ2p2d3dzeHhvd2hmYmt0cm5qIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjYzNjc2NDIsImV4cCI6MTk4MTk0MzY0Mn0.xcCludLuJeTCkH3rsrGy3YvHp1_a6L3zNKRjkToFd1Q',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData.dark().copyWith(
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
      },
    );
  }
}