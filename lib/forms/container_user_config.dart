import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/pages_user_main/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContainerUserConfig extends StatefulWidget {
  const ContainerUserConfig({super.key});

  @override
  State<ContainerUserConfig> createState() => _ContainerUserConfigState();
}

class _ContainerUserConfigState extends State<ContainerUserConfig> {
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.lightBlue,
            expandedHeight: 80,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(15.0),
              centerTitle: true,
              background: Container(
                  decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue,
                    Colors.lightGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ),
              )),
              title: const Text('Configuraciones'),
            ),
          ),
          SliverToBoxAdapter(
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                child: OutlinedButton(
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.lightBlue.shade200),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.grey)),
                  ),
                  onPressed: () {
                    _userProfile(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                          child: Text(
                        'Actualizar datos',
                        style: TextStyle(color: Colors.grey),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ClipRRect(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                child: OutlinedButton(
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.red.shade200),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.red)),
                  ),
                  onPressed: () {
                    _signOut(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                          child: Text(
                        'Cerrar sesion',
                        style: TextStyle(color: Colors.red),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
