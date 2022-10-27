import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  String? _avatarUrl;
  var _loading = false;

  /// Called once a user id is received within `onAuthenticated()`

  /// Called when user taps `Update` button

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      context.showSnackBar(message: error.message, backgroundColor: Colors.red);
    } catch (error) {
      context.showSnackBar(
          message: 'Unexpected error occured', backgroundColor: Colors.red);
    }
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restauración de contraseña'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.centerRight,
                colors: <Color>[Color.fromARGB(255, 255, 86, 86), Colors.black87]),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(labelText: 'Website'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: null,
            child: Text(_loading ? 'Saving...' : 'Update'),
          ),
          const SizedBox(height: 18),
          TextButton(onPressed: _signOut, child: const Text('Sign Out')),
        ],
      ),
    );
  }
}
