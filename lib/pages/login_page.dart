import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithOtp(
        email: _emailController.text,
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        context.showSnackBar(
            message: 'Revisa tu correo para ingresar',
            backgroundColor: Colors.green);
        _emailController.clear();
      }
    } on AuthException catch (error) {
      context.showSnackBar(
          message: "Ingresa un correo válido", backgroundColor: Colors.red);
    } catch (error) {
      context.showSnackBar(
          message: 'Unexpected error occured', backgroundColor: Colors.red);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child: ListView(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 100)),
            const Center(
                child: Text(
                    'Ingrese su correo para obtener un enalce de registro',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center)),
            const SizedBox(height: 40),
            TextFormField(
              cursorColor: Colors.white,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Correo electrónico",
                labelStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 40),
            (_isLoading == false)
                ? ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    child: const Text('Obtener enlace de registro'),
                  )
                : Platform.isAndroid
                    ? const Center(child: CircularProgressIndicator())
                    : const Center(child: CupertinoActivityIndicator())
          ],
        ),
      ),
    );
  }
}
