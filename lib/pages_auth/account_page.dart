import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        Fluttertoast.showToast(msg: 'Cuenta creada correctamente');

        signOut(context);
      }
    } on PostgrestException catch (error) {
      print(error);
      Fluttertoast.showToast(msg: 'Algo salió mal');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Algo salió mal');
    }
    setState(() {
      _loading = false;
    });
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
  Widget _showAnimateOnBackPress(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning,
        size: 50.0,
      ),
      iconColor: Colors.red,
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Center(
              child: Text(
                'Al salir, deberá seleccionar la opción de "Olvidé mi contraseña" para ingresar correctamente a la aplicación',
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
            backgroundColor: MaterialStatePropertyAll(Colors.red),
          ),
          child: const Text(
            'Salir',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            signOut(context);
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.grey),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
void _onBackPress() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimateOnBackPress(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBackPress();

        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeSelect(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Registro de datos'),
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: barColor()),
            ),
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
      ),
    );
  }
}
