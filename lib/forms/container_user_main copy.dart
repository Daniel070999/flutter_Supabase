import 'package:flutter/material.dart';
import 'package:fluttersupabase/pages_user_main/user_new_note.dart';

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
                    Colors.lightGreen,
                    Colors.lightBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ),
              )),
              title: const Text('Menu principal'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    alignment: Alignment.centerLeft,
                    image: AssetImage("images/notes.png"),
                  )),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlinedButton(
                      onPressed: () {
                        _newNote(context);
                      },
                      child: const Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          'Agregar nota',
                          style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 2,
                              color: Colors.black),
                        ),
                      ),
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
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                    alignment: Alignment.centerLeft,
                    image: AssetImage("images/interrogation.png"),
                  )),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          'Trabajando...',
                          style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 2,
                              color: Colors.grey),
                        ),
                      ),
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
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                    alignment: Alignment.centerLeft,
                    image: AssetImage("images/interrogation.png"),
                  )),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          'Trabajando...',
                          style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 2,
                              color: Colors.grey),
                        ),
                      ),
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
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.5,
                    alignment: Alignment.centerLeft,
                    image: AssetImage("images/interrogation.png"),
                  )),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          'Trabajando...',
                          style: TextStyle(
                              fontSize: 28,
                              letterSpacing: 2,
                              color: Colors.grey),
                        ),
                      ),
                    ),
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
