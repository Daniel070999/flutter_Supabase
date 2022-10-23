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
  bool _isLoadingLogin = false;
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

  Future<void> _signInAgain() async {
    setState(() {
      _isLoadingLogin = true;
    });
    context.showSnackBar(
        message: "Proximamente", backgroundColor: Colors.yellow);
    setState(() {
      _isLoadingLogin = false;
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
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightGreen,
                Colors.lightBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Inicio de Sesion",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Bienvenido",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/login.png'),
                          scale: 1.0,
                          alignment: Alignment.topCenter),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 250,
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: const TextStyle(color: Colors.lightBlue),
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Correo electrónico",
                              labelStyle:
                                  const TextStyle(color: Colors.lightBlue),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.lightBlue,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.lightBlue,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.lightBlue, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          (_isLoading == false)
                              ? OutlinedButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.lightBlue),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.lightBlue),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: Colors.lightBlue)),
                                  ),
                                  onPressed: _isLoading ? null : _signIn,
                                  child:
                                      const Text('Obtener enlace de registro'),
                                )
                              : Platform.isAndroid
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const Center(
                                      child: CupertinoActivityIndicator()),
                          const SizedBox(
                            height: 10.0,
                          ),
                          (_isLoadingLogin == false)
                              ? OutlinedButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.lightBlue),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.lightBlue),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: Colors.lightBlue)),
                                  ),
                                  onPressed: _isLoadingLogin ? null : _signInAgain,
                                  child: const Text('Iniciar Sesion'),
                                )
                              : Platform.isAndroid
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const Center(
                                      child: CupertinoActivityIndicator())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
