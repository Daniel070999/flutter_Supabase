import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';

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
  final _validateNoteUpdate = GlobalKey<FormState>();
  String _newTitleUpdate = '';
  String _newDescriptionUpdate = '';
  bool _loadingNotes = false;
  bool _titleUpdate = false;
  bool _descriptionUpdate = false;

  Future<void> _saveNote(BuildContext context) async {
    showLoaderDialog(context, 'Guardando nota');
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
        Navigator.pop(context);
      }
    } catch (e) {
      context.showSnackBar(message: e.toString(), backgroundColor: Colors.red);
    }
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _getNotes();
    });
    Navigator.pop(context);
  }

  Future<void> _updateNote(BuildContext context, String idNote) async {
    showLoaderDialog(context, 'Actualizando nota');
    setState(() {});
    try {
      final title = _newTitleUpdate;
      final description = _newDescriptionUpdate;
      final createAt = DateTime.now().toIso8601String();
      final id = idNote;
      final data = {
        'update_at': createAt,
        'title': title,
        'description': description
      };
      await supabase.from('notes').update(data).eq('id', id);
      if (mounted) {
        Navigator.pop(context);
        _titleUpdate = false;
        _descriptionUpdate = false;
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
    Navigator.pop(context);
  }

  Future<List> _getNotes() async {
    setState(() {
      _loadingNotes = true;
    });
    try {
      final idUser = supabase.auth.currentUser!.id;
      data = await supabase
          .from('notes')
          .select('title , description, id')
          .eq('id_notes_user', idUser);
    } catch (e) {
      context.showSnackBar(message: e.toString(), backgroundColor: Colors.red);
    }
    setState(() {
      _loadingNotes = false;
    });
    return data;
  }

  Future<void> _deleteNote(BuildContext context, String idNote) async {
    showLoaderDialog(context, 'Eliminando nota');
    try {
      String id = idNote.trim();
      await supabase.from('notes').delete().eq('id', id);
      if (mounted) {
        Navigator.pop(context);
        setState(() {
          _getNotes();
        });
      }
    } catch (e) {
      context.showSnackBar(message: e.toString(), backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  Future<void> _viewDeleteNote(
      BuildContext context, String titleNote, String idNote) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning,
            size: 50.0,
          ),
          iconColor: Colors.red,
          actionsAlignment: MainAxisAlignment.center,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Center(
                  child: Text(
                    '¿Desea eliminar la nota?',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(titleNote),
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _deleteNote(context, idNote);
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmNoUpdate(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning,
            size: 50.0,
          ),
          iconColor: Colors.red,
          actionsAlignment: MainAxisAlignment.center,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text(
              '¿Esta seguro que desea salir sin guardar los cambios?'),
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'Salir sin guardar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _titleUpdate = false;
                _descriptionUpdate = false;
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _viewNote(BuildContext context, String titleNote,
      String descriptionNote, String idNote) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: SingleChildScrollView(
            child: Form(
              key: _validateNoteUpdate,
              child: Column(children: [
                TextFormField(
                  onChanged: (value) {
                    if (value != titleNote) {
                      setState(() {
                        _titleUpdate = true;
                        _newTitleUpdate = value;
                      });
                    }
                  },
                  initialValue: titleNote,
                  maxLines: 1,
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Título",
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  onChanged: (value) {
                    if (value != descriptionNote) {
                      setState(() {
                        _descriptionUpdate = true;
                        _newDescriptionUpdate = value;
                      });
                    }
                    return;
                  },
                  initialValue: descriptionNote,
                  maxLines: 10,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_validateNoteUpdate.currentState!.validate()) {
                  _updateNote(context, idNote);
                }
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_titleUpdate != true) {
                  if (_descriptionUpdate != true) {
                    Navigator.of(context).pop();
                  } else {
                    _confirmNoUpdate(context);
                  }
                } else {
                  _confirmNoUpdate(context);
                }
              },
            ),
          ],
        );
      },
    );
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
        padding: const EdgeInsets.all(5.0),
        child: (_loadingNotes == false)
            ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String titleNote = data[index]['title'];
                  String descriptionNote = data[index]['description'];
                  String iDNote = data[index]['id'];
                  return Column(
                    children: [
                      ListTile(
                        onLongPress: () {
                          _viewDeleteNote(context, titleNote, iDNote);
                        },
                        onTap: () {
                          _viewNote(
                              context, titleNote, descriptionNote, iDNote);
                        },
                        minVerticalPadding: 10,
                        title: Text('${data[index]['title']}'),
                        subtitle: Text('${data[index]['description']}'),
                      ),
                    ],
                  );
                },
              )
            : Platform.isAndroid
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Cargando notas'),
                      SizedBox(
                        height: 20.0,
                      ),
                      CircularProgressIndicator()
                    ],
                  ))
                : Center(
                    child: Column(
                    children: const [
                      Text('Cargando notas'),
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
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.indigo.withOpacity(1),
                            Colors.teal.withOpacity(0.5),
                            Colors.transparent,
                          ]),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      )),
                  padding: const EdgeInsets.all(30.0),
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
