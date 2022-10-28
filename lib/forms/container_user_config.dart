import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
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
                padding: const EdgeInsets.all(8.0),
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
