import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/forms/menu_scree.dart';
import 'package:fluttersupabase/pages_user_main/user_main.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      
      duration: const Duration(milliseconds: 400),
      controller: zoomDrawerController,
      menuScreen: const MenuScreen(),
      mainScreen: const UserMain(),
      borderRadius: 25.0,
      showShadow: true,
      angle: -10.0,
      drawerShadowsBackgroundColor: Colors.grey[300]!,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: menuBackgroundColor()
    );
  }
}
