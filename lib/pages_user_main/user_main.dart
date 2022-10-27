import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';

class UserMain extends StatefulWidget {
  UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

Future<void> _quemas(BuildContext context) async {
  await supabase.auth.signOut();
  Navigator.of(context).pushReplacementNamed('/');
}

Future<void> _resetPass(BuildContext context) async {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.of(context).pushReplacementNamed('/reset');
  });
}

class _UserMainState extends State<UserMain> {
  @override
  Widget build(BuildContext context) {
    Object? parametros = ModalRoute.of(context)!.settings.arguments;
    if (parametros == 'resetPass') {
      _resetPass(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Main'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.centerRight,
                colors: <Color>[Colors.red, Colors.black87]),
          ),
        ),
      ),
      body: Container(
        child: OutlinedButton(
            onPressed: () {
              _quemas(context);
            },
            child: Text('ads')),
      ),
    );
  }
}
