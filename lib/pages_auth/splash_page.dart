import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

String _stateAuth = 'defect';

class _SplashPageState extends State<SplashPage> {
  bool _redicrectCalled = false;

  final _usernameProfile = TextEditingController();

  @override
  void initState() {
    _preferencesAnimationLoad();
    super.initState();
  }

  Future<void> _preferencesAnimationLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool('animationState');
    final bool? themeSave = prefs.getBool('theme');
    if (repeat != null) {
      setState(() {
        animationState = repeat;
      });
    }
    if (themeSave != null) {
      setState(() {
        theme = themeSave;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateStateAuth();
    _redirect();
  }

  Future<void> _updateStateAuth() async {
    final authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        // handle signIn
        _stateAuth = 'resetPass';
      } else {
        _stateAuth = 'SingIn';
      }
    });
  }

  Future<void> _createUserName() async {
    const userName = 'empty';
    const lastname = 'empty';
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'username': userName,
      'lastname': lastname,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
    } catch (error) {
      context.showSnackBar(
          message: 'Unexpeted error occured',
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
    }
  }

  Future<void> _redirect() async {
    if (_redicrectCalled || !mounted) {
      return;
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.wifi) ||
        (connectivityResult == ConnectivityResult.ethernet)) {
      await Future.delayed(Duration.zero);

      _redicrectCalled = true;
      final session = supabase.auth.currentSession;
      if (session != null) {
        try {
          final getIdUserAuth = supabase.auth.currentUser?.id;

          final getName = await supabase
              .from('profiles')
              .select('username')
              .eq('id', getIdUserAuth)
              .single() as Map;

          _usernameProfile.text = getName['username'];

          if (_usernameProfile.text.contains('empty')) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/account');
            }
          } else {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/drawer',
                  arguments: _stateAuth);
            }
          }
        } catch (e) {
          if (e.toString().endsWith('null)')) {
            _createUserName();
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/account');
            }
          } else {
            if (mounted) {
              Navigator.of(context)
                  .pushReplacementNamed('/drawer', arguments: _stateAuth);
            }
          }
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/noInternet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
          child: CircularProgressIndicator()),
    );
  }
}
