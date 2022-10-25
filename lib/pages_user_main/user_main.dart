import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

Future<void> _quemas(BuildContext context) async {
  await supabase.auth.signOut();
  Navigator.of(context).pushReplacementNamed('/');
}

class _UserMainState extends State<UserMain> {
  @override
  Widget build(BuildContext context) {
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
