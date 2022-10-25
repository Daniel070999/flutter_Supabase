import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _redicrectCalled = false;
  final _usernameProfile = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
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
    await Future.delayed(Duration.zero);
    if (_redicrectCalled || !mounted) {
      return;
    }

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
          Navigator.of(context).pushReplacementNamed('/userMain');
        }
      } catch (e) {
        _createUserName();
        Navigator.of(context).pushReplacementNamed('/account');
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
