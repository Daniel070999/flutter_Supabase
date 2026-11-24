import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/pages_user_main/user_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  Future<void> _preferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animationState', animationState);
    await prefs.setBool('theme', theme);
  }

  Future<void> _getProfile() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      if (!mounted) return;
      setState(() {
        _usernameController.text = (data['username'] ?? '') as String;
        _lastnameController.text = (data['lastname'] ?? '') as String;
      });
    } on PostgrestException {
      // Ignorado silenciosamente si no hay perfil disponible aún.
    } catch (_) {
      // Ignorado silenciosamente.
    }
  }

  Future<void> _userProfile(BuildContext context) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserProfileUpdate(),
        ),
      );
    } catch (_) {
      Fluttertoast.showToast(msg: 'Algo salió mal');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = supabase.auth.currentUser?.email ?? '';
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
                        'images/lottie/logo.zip',
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
                            '${_usernameController.text}\n${_lastnameController.text}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SelectableText(
                        currentEmail,
                        style: const TextStyle(color: Colors.white),
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
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Tema oscuro'),
                            Switch(
                              value: theme,
                              onChanged: (value) {
                                setState(() {
                                  theme = value;
                                });
                                _preferences();
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/drawer',
                                );
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
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Animaciones'),
                            Switch(
                              value: animationState,
                              onChanged: (value) {
                                setState(() {
                                  animationState = value;
                                });
                                _preferences();
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/drawer',
                                );
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
                            backgroundColor: WidgetStateProperty.all(
                              Colors.white.withValues(alpha: 0.8),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
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
                        height: 40,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.white.withValues(alpha: 0.8),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () {
                            acerca(context);
                          },
                          child: const Center(
                            child: Text(
                              'Acerca de la Aplicación',
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
                            backgroundColor: WidgetStateProperty.all(
                              Colors.white.withValues(alpha: 0.8),
                            ),
                            overlayColor: WidgetStateProperty.all(
                              Colors.red.shade200,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () {
                            signOut(context);
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
