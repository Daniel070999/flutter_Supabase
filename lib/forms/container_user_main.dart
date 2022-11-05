import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/pages_user_main/user_new_note.dart';
import 'package:fluttersupabase/pages_user_main/user_read_qr.dart';

class ContainerUserMain extends StatefulWidget {
  const ContainerUserMain({super.key});

  @override
  State<ContainerUserMain> createState() => _ContainerUserMainState();
}

class _ContainerUserMainState extends State<ContainerUserMain> {
  Future<void> _newNote(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewNote(),
        ));
  }

  Future<void> _readQR(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ReadQR(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        child: CustomScrollView(
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
                      Colors.lightGreen,
                      Colors.lightBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                )),
                title: const Text(
                  'Menu principal',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  child: GestureDetector(
                    onTap: () {
                      _newNote(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white),
                      height: 100,
                      child: Row(
                        children: const [
                          Image(
                            image: AssetImage('images/notes.png'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'LISTA DE NOTAS',
                            style: TextStyle(fontSize: 22),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white),
                      height: 100,
                      child: Row(
                        children: const [
                          Image(
                            image: AssetImage('images/qr.png'),
                          ),
                          Text(
                            'LECTOR DE CÓDIGO QR \n Y CÓDIGO DE BARRAS',
                            style: TextStyle(fontSize: 22),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white),
                      height: 100,
                      child: Row(
                        children: const [
                          Image(
                            image: AssetImage('images/translate.png'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'TRADUCTOR DE TEXTO',
                            style: TextStyle(fontSize: 22),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white),
                      height: 100,
                      child: Row(
                        children: const [
                          Image(
                            image: AssetImage('images/capturetext.png'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'TEXTO EN IMAGEN',
                            style: TextStyle(fontSize: 22),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
