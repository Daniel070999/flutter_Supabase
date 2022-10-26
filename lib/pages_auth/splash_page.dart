import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
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
        print('cambie la clabe');
        _stateAuth = 'resetPass';
      } else {
        print('inicio normal');
        _stateAuth = 'SingIn';
      }
    });
    print('valor actual ----' + _stateAuth);
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
          message: 'Unexpeted error occured', backgroundColor: Colors.red);
    }
  }

  Future<void> _redirect() async {
    if (_redicrectCalled || !mounted) {
      return;
    }

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
          Navigator.of(context).pushReplacementNamed('/account');
        } else {
          Navigator.pushReplacementNamed(context, '/userMain',
              arguments: _stateAuth);
        }
      } catch (e) {
        print(e);
        if (e.toString().endsWith('null)')) {
          print('vacio');
          _createUserName();
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/account');
          }
        } else {
          Navigator.of(context)
              .pushReplacementNamed('/userMain', arguments: _stateAuth);
          print('si hay');
        }
        //
        //   print(e);
        //
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
