import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttersupabase/forms/container_user_main.dart';
import 'package:fluttersupabase/pages_user_main/user_profile.dart';

class UserMain extends StatefulWidget {
  UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int statePage = 0;

  Future<void> _resetPass(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/reset');
    });
  }

  @override
  Widget build(BuildContext context) {
    Object? parametros = ModalRoute.of(context)!.settings.arguments;
    if (parametros == 'resetPass') {
      _resetPass(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu principal',
        ),
        leading: IconButton(
            onPressed: () {
              if (ZoomDrawer.of(context)!.isOpen()) {
                ZoomDrawer.of(context)!.close();
              } else {
                ZoomDrawer.of(context)!.open();
              }
            },
            icon: const Icon(
              Icons.menu_open_rounded,
              color: Colors.white,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(begin: Alignment.centerLeft, colors: <Color>[
              Colors.green,
              Colors.blue.shade300,
            ]),
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: const Center(child: ContainerUserMain()),
    );
  }
}
