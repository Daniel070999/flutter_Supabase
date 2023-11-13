import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _validatedPass = GlobalKey<FormState>();
  var _loading = false;

  /// Called once a user id is received within `onAuthenticated()`

  /// Called when user taps `Update` button


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateAuth() async {
    setState(() {
      _loading = true;
    });
    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          password: _confirmNewPasswordController.text,
        ),
      );
      final User? updatedUser = res.user;
      _passwordUpdate();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Algo salió mal');
    }
    setState(() {
      _loading = false;
    });
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
                '¿Salir sin actualizar su contraseña?',
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

  Widget _showAnimatepasswordUpdate(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.check_circle_outline_outlined,
        size: 60.0,
      ),
      iconColor: Colors.lightGreen,
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Center(
              child: Text(
                'Su contraseña ha sido actualizada correctamente.',
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
            backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
          ),
          child: const Text(
            'Aceptar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            signOut(context);
          },
        ),
        const SizedBox(
          height: 20.0,
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

  void _passwordUpdate() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimatepasswordUpdate(ctx),
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
            title: const Text('Restauración de contraseña'),
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: barColor()),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _validatedPass,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                children: [
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
                    controller: _newPasswordController,
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
                  const SizedBox(height: 18.0),
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Este campo no puede estar vacio';
                      } else if (_newPasswordController.text !=
                          value.toString()) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                    obscureText: true,
                    style: const TextStyle(color: Colors.lightBlue),
                    controller: _confirmNewPasswordController,
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
                            _newPasswordController.text.trimRight();
                            _confirmNewPasswordController.text.trimRight();
                            if (_validatedPass.currentState!.validate()) {
                              _updateAuth();
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
