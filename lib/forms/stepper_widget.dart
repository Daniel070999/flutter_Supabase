import 'package:fluttersupabase/constants.dart';

import 'package:flutter/material.dart';

class stepper_widget extends StatefulWidget {
  const stepper_widget({super.key});

  @override
  State<stepper_widget> createState() => _stepper_widgetState();
}

class _stepper_widgetState extends State<stepper_widget> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
  }

  Future<void> _updateUser(BuildContext context) async {
    context.showSnackBar(
        message: _phoneController.text, backgroundColor: Colors.green);
  }

  int _index = 0;
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
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          steps: <Step>[
            Step(
              title: Text('Datos para inicio de sesion'),
              content: Column(
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(color: Colors.lightBlue),
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Número de teléfono",
                      labelStyle: const TextStyle(color: Colors.lightBlue),
                      prefixIcon: const Icon(
                        Icons.phone_android,
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
                    obscureText: true,
                    style: const TextStyle(color: Colors.lightBlue),
                    controller: null,
                    decoration: InputDecoration(
                      labelText: "Ingrese una contraseña",
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
                    obscureText: true,
                    style: const TextStyle(color: Colors.lightBlue),
                    controller: null,
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
                  OutlinedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size.fromWidth(150)),
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
                      _updateUser(context);
                    },
                    child: const Text('Guardar'),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            Step(
              title: Text('Datos de usuario'),
              content: Text('Nombre y apellido'),
            ),
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (_index == 1)
                    ? const OutlinedButton(
                        onPressed: null,
                        child: Text('Siguiente'),
                      )
                    : (_phoneController.text.isEmpty)
                        ? OutlinedButton(
                            onPressed: null,
                            child: const Text('Siguiente'),
                          )
                        : OutlinedButton(
                            onPressed: details.onStepContinue,
                            child: const Text('Siguiente'),
                          ),
                const SizedBox(
                  width: 50.0,
                ),
                (_index == 0)
                    ? const OutlinedButton(
                        onPressed: null,
                        child: Text('Regresar'),
                      )
                    : OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Regresar'),
                      ),
              ],
            );
          },
        ),
      ],
    );
  }
}
