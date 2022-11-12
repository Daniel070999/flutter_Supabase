import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/forms/drawer_screen.dart';
import 'package:fluttersupabase/pages_user_main/user_profile.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _usernameController = TextEditingController();
  final _lastnameController = TextEditingController();
  var _loading = false;
  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _preferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('animationState', animationState);
    prefs.setBool('theme', theme);
  }

  

  Future<void> _getProfile() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single() as Map;
      setState(() {
        _usernameController.text = (data['username'] ?? '') as String;
        _lastnameController.text = (data['lastname'] ?? '') as String;
      });
    } on PostgrestException catch (error) {
      context.showSnackBar(
          message: error.message,
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    } catch (error) {
      context.showSnackBar(
          message: 'Unexpected exception occurred',
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    }
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

  Future<void> _userProfile(BuildContext context) async {
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfileUpdate(),
          ));
    } catch (error) {
      context.showSnackBar(
          message: 'Unexpected error occured',
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: barColorScreen()),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Lottie.asset(
                        'images/lottie/user.zip',
                        repeat: animationState,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _usernameController.text +
                                  "\n" +
                                  _lastnameController.text,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ],
                        )),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SelectableText(
                          supabase.auth.currentUser!.email.toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white.withOpacity(0.8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Tema oscuro"),
                            Switch(
                              value: theme,
                              onChanged: (value) {
                                setState(() {
                                  theme = value;
                                  Navigator.pushReplacementNamed(
                                      context, '/drawer');
                                  _preferences();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white.withOpacity(0.8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Animaciones"),
                            Switch(
                              value: animationState,
                              onChanged: (value) {
                                setState(() {
                                  animationState = value;
                                  Navigator.pushReplacementNamed(
                                      context, '/drawer');
                                  _preferences();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        color: Colors.transparent,
                        height: 40,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.8)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                          onPressed: () {
                            _userProfile(context);
                          },
                          child: const Center(
                            child: Text(
                              'Actualizar Datos',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        color: Colors.transparent,
                        height: 40.0,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.8)),
                            overlayColor:
                                MaterialStateProperty.all(Colors.red.shade200),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                          ),
                          onPressed: () {
                            _signOut(context);
                          },
                          child: const Center(
                            child: Text(
                              'Cerrar sesion',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
