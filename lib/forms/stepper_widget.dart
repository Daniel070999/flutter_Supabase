import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttersupabase/constants.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class stepper_widget extends StatefulWidget {
  const stepper_widget({super.key});

  @override
  State<stepper_widget> createState() => _stepper_widgetState();
}

class _stepper_widgetState extends State<stepper_widget> {
  bool _isLoading = false;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  bool _confirmedData = false;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
  }

  Future<void> _updateUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final UserResponse res = await supabase.auth.updateUser(
      UserAttributes(
        //si se desea actualizar el campo del telefono se debe enviar tambien el correo (talvez)
        password: _passwordConfirmController.text,
      ),
    );
    final User? updatedUser = res.user;

    setState(() {
      _isLoading = false;
      _confirmedData = true;
      _passwordController.clear();
      _passwordConfirmController.clear();
    });
    context.showSnackBar(
        message: 'Nueva contraseña creada exitosamente',
        backgroundColor: Colors.lightGreen);
  }

  int _index = 0;
  final _keyFormValidate = GlobalKey<FormState>();
  final _keyFormValidate2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stepper(
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
                _confirmedData = false;
              });
            }
          },
          onStepContinue: () {
            if (_index <= 0) {
              setState(() {
                _index += 1;
              });
            }
          },
          steps: <Step>[
            Step(
              title: Text('Datos para inicio de sesion'),
              content: Form(
                key: _keyFormValidate,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Este campo no puede estar vacío';
                        } else if (value.toString().length < 6) {
                          return 'No puede haber menos de 6 caracteres';
                        }
                      },
                      onChanged: (value) {
                        setState(() {});
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
                    const SizedBox(height: 15.0),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Este campo no puede estar vacío';
                        } else if (value.toString() !=
                            _passwordController.text) {
                          return 'La contraseña no coincide';
                        }
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      obscureText: true,
                      style: const TextStyle(color: Colors.lightBlue),
                      controller: _passwordConfirmController,
                      decoration: InputDecoration(
                        labelText: "Confirmar contraeña",
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
                    const SizedBox(height: 15.0),
                    (_isLoading == false)
                        ? OutlinedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromWidth(150)),
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
                              if (_keyFormValidate.currentState!.validate()) {
                                _updateUser(context);
                              }
                            },
                            child: const Text('Guardar'),
                          )
                        : Platform.isAndroid
                            ? const Center(child: CircularProgressIndicator())
                            : const Center(child: CupertinoActivityIndicator()),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
            Step(
              title: Text('Datos de usuario'),
              content: Form(
                key: _keyFormValidate2,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Este campo no puede estar vacío';
                        } else if (value.toString().length < 6) {
                          return 'No puede haber menos de 6 caracteres';
                        }
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      obscureText: true,
                      style: const TextStyle(color: Colors.lightBlue),
                      controller: null,
                      decoration: InputDecoration(
                        labelText: "Nombre",
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
                    const SizedBox(height: 15.0),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Este campo no puede estar vacío';
                        } else if (value.toString() !=
                            _passwordController.text) {
                          return 'La contraseña no coincide';
                        }
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      obscureText: true,
                      style: const TextStyle(color: Colors.lightBlue),
                      controller: null,
                      decoration: InputDecoration(
                        labelText: "Apellido",
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
                    const SizedBox(height: 15.0),
                    (_isLoading == false)
                        ? OutlinedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromWidth(150)),
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
                              if (_keyFormValidate2.currentState!.validate()) {}
                            },
                            child: const Text('Guardar'),
                          )
                        : Platform.isAndroid
                            ? const Center(child: CircularProgressIndicator())
                            : const Center(child: CupertinoActivityIndicator()),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                (_index == 1)
                    ? const ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        onPressed: null,
                        child: Text(''),
                      )
                    : (_confirmedData == false)
                        ? const OutlinedButton(
                            onPressed: null,
                            child: Text('Continuar'),
                          )
                        : OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.lightBlue),
                            ),
                            onPressed: details.onStepContinue,
                            child: const Text(
                              'Continuar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                const SizedBox(
                  width: 50.0,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
