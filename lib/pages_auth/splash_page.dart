import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

String _stateAuth = 'defect';

class _SplashPageState extends State<SplashPage> {
  bool _redirectCalled = false;
  StreamSubscription<AuthState>? _authSubscription;
  final _usernameProfile = TextEditingController();

  @override
  void initState() {
    super.initState();
    _preferencesAnimationLoad();
    _updateStateAuth();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _usernameProfile.dispose();
    super.dispose();
  }

  Future<void> _preferencesAnimationLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool('animationState');
    final bool? themeSave = prefs.getBool('theme');
    if (!mounted) return;
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
    _redirect();
  }

  void _updateStateAuth() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
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
    if (user == null) return;
    final updates = {
      'id': user.id,
      'username': userName,
      'lastname': lastname,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
    } catch (_) {
      Fluttertoast.showToast(msg: 'Algo salió mal');
    }
  }

  Future<void> _redirect() async {
    if (_redirectCalled || !mounted) {
      return;
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    if (!mounted) return;

    if (hasInternetConnection(connectivityResult)) {
      await Future.delayed(Duration.zero);
      if (!mounted) return;

      _redirectCalled = true;
      final session = supabase.auth.currentSession;
      final getIdUserAuth = supabase.auth.currentUser?.id;

      if (session != null && getIdUserAuth != null) {
        try {
          final getName = await supabase
              .from('profiles')
              .select('username')
              .eq('id', getIdUserAuth)
              .single();

          _usernameProfile.text = (getName['username'] ?? '').toString();

          if (!mounted) return;
          if (_usernameProfile.text.contains('empty')) {
            Navigator.of(context).pushReplacementNamed('/account');
          } else {
            Navigator.pushReplacementNamed(
              context,
              '/drawer',
              arguments: _stateAuth,
            );
          }
        } catch (e) {
          if (e.toString().endsWith('null)')) {
            await _createUserName();
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/account');
            }
          } else if (mounted) {
            Navigator.of(context).pushReplacementNamed(
              '/drawer',
              arguments: _stateAuth,
            );
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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
