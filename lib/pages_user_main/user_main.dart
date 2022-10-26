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
    print(parametros.toString()+"-------llegando");
    if (parametros == 'resetPass') {
      _resetPass(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('que mas'),
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
