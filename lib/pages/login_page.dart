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
  late final TextEditingController _passwordController;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signInEmail() async {
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
        Navigator.of(context).pop();
      }
    } on AuthException catch (error) {
      var text_in = error.toString();
      if (text_in.endsWith("422)")) {
        context.showSnackBar(
            message: 'Correo no valido', backgroundColor: Colors.red);
      } else if (text_in.endsWith("429)")) {
        context.showSnackBar(
            message: 'Vuelva a enviar luego de 60 segundos',
            backgroundColor: Colors.red);
      } else if (text_in.endsWith("400)")) {
        context.showSnackBar(
            message: 'Ingrese un correo electrónico',
            backgroundColor: Colors.red);
      }else {
        context.showSnackBar(
            message: 'Error al enviar el correo', backgroundColor: Colors.red);
      }
      print(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    context.showSnackBar(message: 'Próximamente', backgroundColor: Colors.grey);
    _emailController.clear();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signInAgain() async {
    setState(() {
      _isLoadingLogin = true;
    });

    if (_emailController.text == "" || _passwordController.text == "") {
      context.showSnackBar(
          message: "Ingrese los datos", backgroundColor: Colors.red);
    } else {
      try {
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        final Session? session = res.session;
        final User? user = res.user;
      } catch (e) {
        context.showSnackBar(
            message: "Los datos ingresados son incorrectos",
            backgroundColor: Colors.red);
      }
    }

    setState(() {
      _isLoadingLogin = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            style: const TextStyle(color: Colors.lightBlue),
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Clave",
                              labelStyle:
                                  const TextStyle(color: Colors.lightBlue),
                              prefixIcon: const Icon(
                                Icons.lock,
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
                            height: 10.0,
                          ),
                          (_isLoadingLogin == false)
                              ? OutlinedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        const Size.fromWidth(200)),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.lightBlue),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.lightGreen),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: Colors.lightGreen)),
                                  ),
                                  onPressed:
                                      _isLoadingLogin ? null : _signInAgain,
                                  child: const Text('Iniciar Sesion'),
                                )
                              : Platform.isAndroid
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const Center(
                                      child: CupertinoActivityIndicator()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    barrierColor: Colors.black54,
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      contentPadding:
                                          const EdgeInsets.all(20.0),
                                      children: [
                                        const Text(
                                          "Ingrese su correo electrónico y luego eliga una opción",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        TextFormField(
                                          style: const TextStyle(
                                              color: Colors.lightBlue),
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            labelText: "Correo electrónico",
                                            labelStyle: const TextStyle(
                                                color: Colors.lightBlue),
                                            prefixIcon: const Icon(
                                              Icons.email_outlined,
                                              color: Colors.lightBlue,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              borderSide: const BorderSide(
                                                color: Colors.lightBlue,
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.lightBlue,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        OutlinedButton(
                                          style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size.fromWidth(200)),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.lightBlue),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.lightGreen),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                            ),
                                            side: MaterialStateProperty.all(
                                                const BorderSide(
                                                    color: Colors.lightGreen)),
                                          ),
                                          onPressed: _signInEmail,
                                          child: Text(_isLoading
                                              ? 'enviando'
                                              : 'Obtener enlace de registro'),
                                        ),
                                        OutlinedButton(
                                          style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size.fromWidth(200)),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.lightBlue),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.orange),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                            ),
                                            side: MaterialStateProperty.all(
                                                const BorderSide(
                                                    color: Colors.orange)),
                                          ),
                                          onPressed: _resetPassword,
                                          child: Text(_isLoading
                                              ? 'enviando'
                                              : 'Olvide mi contraseña'),
                                        ),
                                        OutlinedButton(
                                          style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size.fromWidth(200)),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.lightBlue),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                            ),
                                            side: MaterialStateProperty.all(
                                                const BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Más opciones",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
