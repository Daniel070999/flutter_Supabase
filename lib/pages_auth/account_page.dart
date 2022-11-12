import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _validatedForm = GlobalKey<FormState>();
  var _loading = false;

  /// Called once a user id is received within `onAuthenticated()`

  /// Called when user taps `Update` button
  Future<void> _updateProfileAndAuth() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    final lastname = _lastnameController.text;
    final password = _passwordConfirmController.text;
    final user = supabase.auth.currentUser;
    final id = user!.id;
    final updates = {
      'username': userName,
      'lastname': lastname,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').update(updates).eq('id', id);
      await supabase.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );
      if (mounted) {
        context.showSnackBar(
            message: 'Cuenta creada correctamente',
            backgroundColor: Colors.lightGreen,icon: Icons.check_circle_outline_outlined);
            _signOut(context);
      }
    } on PostgrestException catch (error) {
      print(error);
      context.showSnackBar(
          message: error.toString(),
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    } catch (error) {
      context.showSnackBar(
          message: 'Unexpeted error occured',
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    }
    setState(() {
      _loading = false;
    });
  }
Future<void> _signOut(BuildContext context) async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      context.showSnackBar(
          message: error.message,
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    } catch (error) {
      context.showSnackBar(
          message: 'Unexpected error occured',
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    }
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSelect(),
      home:  Scaffold(
        appBar: AppBar(
          title: const Text('Registro de datos'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient:barColor()
            ),
          ),
          backgroundColor: Colors.lightBlue,
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _validatedForm,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                TextFormField(
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Este campo no puede estar vacio';
                    } else if (value.toString().length < 3) {
                      return 'No puede haber menos de 3 caracteres';
                    }
                  },
                  style: const TextStyle(color: Colors.lightBlue),
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    labelStyle: const TextStyle(color: Colors.lightBlue),
                    prefixIcon: const Icon(
                      Icons.text_snippet_sharp,
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
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Este campo no puede estar vacio';
                    } else if (value.toString().length < 3) {
                      return 'No puede haber menos de 3 caracteres';
                    }
                  },
                  style: const TextStyle(color: Colors.lightBlue),
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    labelText: "Apellido",
                    labelStyle: const TextStyle(color: Colors.lightBlue),
                    prefixIcon: const Icon(
                      Icons.text_snippet_sharp,
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
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Este campo no puede estar vacio';
                    } else if (value.toString().length < 6) {
                      return 'No puede haber menos de 6 caracteres';
                    }
                  },
                  obscureText: true,
                  style: const TextStyle(color: Colors.lightBlue),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Cree una nueva contraseña",
                    labelStyle: const TextStyle(color: Colors.lightBlue),
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
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Este campo no puede estar vacio';
                    } else if (_passwordController.text != value.toString()) {
                      return 'Las contraseñas no coinciden';
                    }
                  },
                  obscureText: true,
                  style: const TextStyle(color: Colors.lightBlue),
                  controller: _passwordConfirmController,
                  decoration: InputDecoration(
                    labelText: "Confirmar contraseña",
                    labelStyle: const TextStyle(color: Colors.lightBlue),
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
                      borderSide:
                          const BorderSide(color: Colors.lightBlue, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                (_loading == false)
                    ? OutlinedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              const Size.fromWidth(200)),
                          overlayColor:
                              MaterialStateProperty.all(Colors.lightBlue),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
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
                          if (_validatedForm.currentState!.validate()) {
                            _updateProfileAndAuth();
                          }
                        },
                        child: const Text('Guardar'),
                      )
                    : Platform.isAndroid
                        ? const Center(child: CircularProgressIndicator())
                        : const Center(child: CupertinoActivityIndicator()),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
