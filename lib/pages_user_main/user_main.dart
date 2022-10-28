import 'package:flutter/material.dart';
import 'package:fluttersupabase/forms/container_user_config.dart';
import 'package:fluttersupabase/forms/container_user_main%20copy.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
        body: (statePage == 0) ? ContainerUserMain() : ContainerUserConfig(),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: GNav(
                onTabChange: (index) {
                  setState(() {
                    statePage = index;
                  });
                },
                backgroundColor: Colors.black,
                rippleColor: Colors.white,
                hoverColor: Colors.white,
                haptic: true,
                tabBorderRadius: 30,
                tabActiveBorder: Border.all(color: Colors.black, width: 1),
                tabBorder: Border.all(color: Colors.transparent, width: 1),
                tabShadow: [BoxShadow(color: Colors.black, blurRadius: 8)],
                curve: Curves.easeInQuart,
                duration: Duration(milliseconds: 900),
                gap: 8,
                color: Colors.grey.shade600,
                activeColor: Colors.white,
                iconSize: 24,
                tabBackgroundColor: Colors.white.withOpacity(0.5),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Menu Principal',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Configuraciones',
                  )
                ]),
          ),
        ));
  }
}
