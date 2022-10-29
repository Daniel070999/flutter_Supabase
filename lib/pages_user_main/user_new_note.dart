import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttersupabase/forms/list_notes.dart';
import 'package:fluttersupabase/main.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

List<dynamic> data = [];

class _NewNoteState extends State<NewNote> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _validateTitle = GlobalKey<FormState>();
  bool _loadingNotes = false;

  Future<void> _saveNote(BuildContext context) async {
    setState(() {});
    try {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final createAt = DateTime.now().toIso8601String();
      final userId = supabase.auth.currentUser!.id;
      final data = {
        'id_notes_user': userId,
        'create_at': createAt,
        'title': title,
        'description': description
      };
      await supabase.from('notes').insert(data);
      if (mounted) {
        context.showSnackBar(
            message: 'Nota creada', backgroundColor: Colors.lightGreen);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      context.showSnackBar(message: e.toString(), backgroundColor: Colors.red);
    }
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _getNotes();
    });
  }

  Future<List> _getNotes() async {
    setState(() {
      _loadingNotes = true;
    });
    try {
      final idUser = supabase.auth.currentUser!.id;
      data = await supabase
          .from('notes')
          .select('title , description')
          .eq('id_notes_user', idUser);
    } catch (e) {
      print(e);
    }
    setState(() {
      _loadingNotes = false;
    });
    return data;
  }

  @override
  void initState() {
    _getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (_loadingNotes == false)
            ? ListNotes(
                items: List<ListItem>.generate(
                  data.length,
                  (i) => (i == -1)
                      ? HeadingItem('ads')
                      : DataNotes(
                          '${data[i]['title']}', ' ${data[i]['description']}'),
                ),
              )
            : Platform.isAndroid
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Cargando notas ;)'),
                      SizedBox(
                        height: 20.0,
                      ),
                      CircularProgressIndicator()
                    ],
                  ))
                : Center(
                    child: Column(
                    children: const [
                      Text('Cargando notas ;)'),
                      CupertinoActivityIndicator()
                    ],
                  )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  height: 700,
                  child: Form(
                    key: _validateTitle,
                    child: Center(
                      child: Column(
                        children: [
                          TextFormField(
                            maxLines: 1,
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: "Título",
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            maxLines: 10,
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(color: Colors.white),
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: "Descripción",
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size.fromWidth(150)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.lightGreen),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.lightGreen.shade200),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(color: Colors.white)),
                                ),
                                onPressed: () {
                                  if (_validateTitle.currentState!.validate()) {
                                    _saveNote(context);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Center(
                                        child: Text(
                                      'Guardar',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              OutlinedButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size.fromWidth(150)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.red.shade200),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                  side: MaterialStateProperty.all(
                                      const BorderSide(color: Colors.white)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _titleController.clear();
                                  _descriptionController.clear();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Center(
                                        child: Text(
                                      'Cancelar',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        elevation: 5,
        label: const Text('Crear'),
        icon: const Icon(Icons.note_add_outlined),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
