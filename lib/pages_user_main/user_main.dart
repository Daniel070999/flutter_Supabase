import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/forms/container_user_main.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  bool _checkedReset = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_checkedReset) return;
    _checkedReset = true;
    final Object? parametros = ModalRoute.of(context)?.settings.arguments;
    if (parametros == 'resetPass') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/reset');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeSelect(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu principal'),
          leading: IconButton(
            onPressed: () {
              final drawer = ZoomDrawer.of(context);
              if (drawer == null) return;
              if (drawer.isOpen()) {
                drawer.close();
              } else {
                drawer.open();
              }
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: barColor(),
            ),
          ),
        ),
        body: const ContainerUserMain(),
      ),
    );
  }
}
