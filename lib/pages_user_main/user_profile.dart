import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileUpdate extends StatefulWidget {
  const UserProfileUpdate({super.key});

  @override
  _UserProfileUpdateState createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate> {
  final _usernameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _validatedFormData = GlobalKey<FormState>();
  final _validatedFormPassword = GlobalKey<FormState>();
  var _loading = false;
  var _loadingPass = false;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single() as Map;
      _usernameController.text = (data['username'] ?? '') as String;
      _lastnameController.text = (data['lastname'] ?? '') as String;
    } on PostgrestException {
      Fluttertoast.showToast(msg: 'No se pudo cargar sus datos');
    } catch (error) {
      Fluttertoast.showToast(msg: 'No se pudo cargar sus datos');
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateProfile(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    final lastname = _lastnameController.text;
    final user = supabase.auth.currentUser;
    final id = user!.id;
    final updates = {
      'username': userName,
      'lastname': lastname,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').update(updates).eq('id', id);
      if (mounted) {
        Fluttertoast.showToast(msg: 'Datos actualizados');
        signOut(context);
      }
    } on PostgrestException {
      Fluttertoast.showToast(msg: 'Algo salió mal');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Algo salió mal');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateAuth() async {
    setState(() {
      _loadingPass = true;
    });
    final password = _passwordConfirmController.text;
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );
      if (mounted) {
        Fluttertoast.showToast(msg: 'Contraseña actualizada');
        signOut(context);
      }
    } on PostgrestException {
      Fluttertoast.showToast(msg: 'Algo salió mal');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Algo salió mal');
    }
    setState(() {
      _loadingPass = false;
      _passwordController.clear();
      _passwordConfirmController.clear();
    });
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Actualización de datos'),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            children: [
              const Center(
                child: Text(
                  'NOTA: Luego de actualizar los datos, se cerrará sesión',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 18),
              Form(
                key: _validatedFormData,
                child: Column(children: [
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Este campo no puede estar vacio';
                      } else if (value.toString().length < 3) {
                        return 'No puede haber menos de 3 caracteres';
                      }
                      return null;
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
                        borderSide: const BorderSide(
                            color: Colors.lightBlue, width: 2.0),
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
                      return null;
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
                        borderSide: const BorderSide(
                            color: Colors.lightBlue, width: 2.0),
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
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.lightGreen)),
                          ),
                          onPressed: () {
                            if (_validatedFormData.currentState!.validate()) {
                              _updateProfile(context);
                            }
                          },
                          child: const Text(
                            'Actualizar datos',
                            style: TextStyle(color: Colors.lightGreen),
                          ),
                        )
                      : Platform.isAndroid
                          ? const Center(child: CircularProgressIndicator())
                          : const Center(child: CupertinoActivityIndicator()),
                  const SizedBox(height: 18.0),
                ]),
              ),
              Form(
                key: _validatedFormPassword,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Este campo no puede estar vacio';
                        } else if (value.toString().length < 6) {
                          return 'No puede haber menos de 6 caracteres';
                        }
                        return null;
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
                          borderSide: const BorderSide(
                              color: Colors.lightBlue, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Este campo no puede estar vacio';
                        } else if (_passwordController.text !=
                            value.toString()) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
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
                          borderSide: const BorderSide(
                              color: Colors.lightBlue, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    (_loadingPass == false)
                        ? OutlinedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromWidth(200)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                              side: MaterialStateProperty.all(
                                  const BorderSide(color: Colors.lightGreen)),
                            ),
                            onPressed: () {
                              if (_validatedFormPassword.currentState!
                                  .validate()) {
                                _updateAuth();
                              }
                            },
                            child: const Text(
                              'Actualizar contraseña',
                              style: TextStyle(color: Colors.lightGreen),
                            ),
                          )
                        : Platform.isAndroid
                            ? const Center(child: CircularProgressIndicator())
                            : const Center(child: CupertinoActivityIndicator()),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
