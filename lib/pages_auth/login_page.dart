import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/pages_no_auth/home_no_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _obscureText = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final StreamSubscription<AuthState> _authStateSubscription;
  final _validatedForm = GlobalKey<FormState>();
  final _validatedFormSheet = GlobalKey<FormState>();

  Future<void> _noAuth() async {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimateNoAuth(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  Widget _showAnimateNoAuth(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      icon: Lottie.asset('images/lottie/question.zip'),
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Center(
              child: Text(
                'Al usar la aplicación sin registrarse se limitarán herramientas y funciones',
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.lightBlue),
          ),
          child: const Text(
            'Ingresar sin registro',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserNoAuth(),
                ));
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
          ),
          child: const Text(
            'Registrarme',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            showMore();
          },
        ),
      ],
    );
  }

  Future<void> _signInEmail() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.wifi) ||
        (connectivityResult == ConnectivityResult.ethernet)) {
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
              backgroundColor: Colors.lightGreen,
              icon: Icons.check_circle_outline_outlined);
          _emailController.clear();
          Navigator.of(context).pop();
        }
      } on AuthException catch (error) {
        if (mounted) {
          var text_input = error.toString();
          if (text_input.endsWith("422)")) {
            context.showSnackBar(
                message: 'Correo no valido',
                backgroundColor: Colors.red,
                icon: Icons.dangerous_outlined);
            Navigator.of(context).pop();
          } else if (text_input.endsWith("429)")) {
            context.showSnackBar(
                message: 'Vuelva a enviar luego de 60 segundos',
                backgroundColor: Colors.red,
                icon: Icons.dangerous_outlined);
            Navigator.of(context).pop();
          } else if (text_input.endsWith("400)")) {
            context.showSnackBar(
                message: 'Ingrese un correo electrónico',
                backgroundColor: Colors.red,
                icon: Icons.dangerous_outlined);
          } else {
            context.showSnackBar(
                message: 'Error al enviar el correo',
                backgroundColor: Colors.red,
                icon: Icons.dangerous_outlined);
            Navigator.of(context).pop();
          }
          print(error.toString());
        }
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/noInternet');
      }
    }
  }

  Future<void> _resetPassword() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.wifi) ||
        (connectivityResult == ConnectivityResult.ethernet)) {
      setState(() {
        _isLoading = true;
      });
      try {
        await supabase.auth.resetPasswordForEmail(
          _emailController.text,
          redirectTo: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
        );
        if (mounted) {
          context.showSnackBar(
              message: 'Revisa tu correo para ingresar',
              backgroundColor: Colors.lightGreen,
              icon: Icons.check_circle_outline_outlined);
          _emailController.clear();
          Navigator.of(context).pop();
        }
      } on AuthException catch (error) {
        if (mounted) {
          context.showSnackBar(
              message: 'Intenta luego de 60 segundos',
              backgroundColor: Colors.red,
              icon: Icons.dangerous_outlined);
          Navigator.of(context).pop();
        }
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/noInternet');
      }
    }
  }

  Future<void> _signInAgain() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.wifi) ||
        (connectivityResult == ConnectivityResult.ethernet)) {
      setState(() {
        _isLoadingLogin = true;
      });

      if (_emailController.text == "" || _passwordController.text == "") {
        if (mounted) {
          context.showSnackBar(
              message: "Ingrese los datos",
              backgroundColor: Colors.red,
              icon: Icons.dangerous_outlined);
        }
      } else {
        try {
          final AuthResponse res = await supabase.auth.signInWithPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          final Session? session = res.session;
          final User? user = res.user;
        } catch (e) {
          if (e.toString().contains('ergjvwwsxxowhfbktrnj.supabase.co')) {
            if (mounted) {
              context.showSnackBar(
                  message: "Revise su conexión a Internet",
                  backgroundColor: Colors.red,
                  icon: Icons.warning_amber_rounded);
            }
          } else {
            if (mounted) {
              context.showSnackBar(
                  message: "Los datos ingresados son incorrectos",
                  backgroundColor: Colors.red,
                  icon: Icons.dangerous_outlined);
            }
          }
        }
      }

      setState(() {
        _isLoadingLogin = false;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/noInternet');
      }
    }
  }

  Future showMore() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(40.0),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.indigo,
                    Colors.teal,
                    Colors.white,
                  ]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              )),
          height: 600,
          child: Form(
            key: _validatedFormSheet,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'Ingrese su correo electrónico y luego seleccione una opción.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Ingrese un correo electrónico';
                      } else if (!value.toString().contains('@') ||
                          !value.toString().contains('.')) {
                        return 'Ingrese un correo válido';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  OutlinedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size.fromWidth(300)),
                      overlayColor: MaterialStateProperty.all(Colors.lightBlue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightGreen),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.lightGreen)),
                    ),
                    onPressed: () {
                      if (_validatedFormSheet.currentState!.validate()) {
                        _emailController.text = _emailController.text.trim();
                        _signInEmail();
                      }
                    },
                    child: Text(
                        _isLoading ? 'enviando' : 'Obtener enlace de registro'),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size.fromWidth(300)),
                      overlayColor: MaterialStateProperty.all(Colors.lightBlue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.orange)),
                    ),
                    onPressed: () {
                      if (_validatedFormSheet.currentState!.validate()) {
                        _resetPassword();
                      }
                    },
                    child:
                        Text(_isLoading ? 'enviando' : 'Olvide mi contraseña'),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size.fromWidth(300)),
                      overlayColor: MaterialStateProperty.all(Colors.lightBlue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.grey)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deletePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('animationState');
    prefs.remove('theme');
    setState(() {
      animationState = true;
      theme = false;
    });
  }

  @override
  void initState() {
    _deletePreferences();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/');
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _validatedForm,
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
                            "Inicio de Sesión",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                              ),
                              child: Column(
                                children: [
                                  Lottie.asset(
                                    'images/lottie/hello.zip',
                                    repeat: true,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '¿No tiene cuenta?/¿Olvidó su contraseña?',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.deepPurple.shade800),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _passwordController.clear();
                                          showMore();
                                        },
                                        child: Text(
                                          "CLIC AQUÍ",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue.shade700,
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return 'Ingrese un correo electrónico';
                                      } else if (!value
                                              .toString()
                                              .contains('@') ||
                                          !value.toString().contains('.')) {
                                        return 'Ingrese un correo válido';
                                      }
                                      return null;
                                    },
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
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return 'Ingrese la contraseña';
                                      }
                                      return null;
                                    },
                                    obscureText: _obscureText,
                                    style: const TextStyle(
                                        color: Colors.lightBlue),
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          child: _obscureText
                                              ? const Icon(Icons.remove_red_eye)
                                              : const Icon(Icons
                                                  .remove_red_eye_outlined)),
                                      labelText: "Clave",
                                      labelStyle: const TextStyle(
                                          color: Colors.lightBlue),
                                      prefixIcon: const Icon(
                                        Icons.lock,
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
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  (_isLoadingLogin == false)
                                      ? OutlinedButton(
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
                                          onPressed: () {
                                            if (_validatedForm.currentState!
                                                .validate()) {
                                              _emailController.text =
                                                  _emailController.text.trim();
                                              _passwordController.text =
                                                  _passwordController.text
                                                      .trim();
                                              _signInAgain();
                                            }
                                          },
                                          child: const Text('Iniciar Sesion'),
                                        )
                                      : Platform.isAndroid
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : const Center(
                                              child:
                                                  CupertinoActivityIndicator()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _noAuth();
                                        },
                                        child: Text(
                                          "Usar aplicación sin registro",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue.shade700,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
