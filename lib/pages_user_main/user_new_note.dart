import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

import 'package:share_plus/share_plus.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

List<dynamic> data = [];

class _NewNoteState extends State<NewNote> with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _validateTitle = GlobalKey<FormState>();
  final _validateNoteUpdate = GlobalKey<FormState>();
  String _newTitleUpdate = '';
  String _newDescriptionUpdate = '';
  String _newIdNoteUpdate = '';
  bool _loadingNotes = false;
  bool _titleUpdate = false;
  bool _descriptionUpdate = false;

  Future<void> _saveNote(BuildContext context) async {
    showLoaderDialog(context, 'Guardando nota', 'images/lottie/save.zip');
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
      Navigator.pop(context);
      if (e.toString().contains('ergjvwwsxxowhfbktrnj.supabase.co')) {
        context.showSnackBar(
            message: "Revise su conexión a Internet",
            backgroundColor: Colors.red,
            icon: Icons.dangerous_outlined);
      }
    }
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _getNotes();
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _updateNote(BuildContext context, String titleUpdate,
      String descriptionUpdate, String idUpdate) async {
    showLoaderDialog(context, 'Actualizando nota', 'images/lottie/update.zip');
    setState(() {});
    try {
      final createAt = DateTime.now().toIso8601String();
      final id = idUpdate;
      final data = {
        'update_at': createAt,
        'title': titleUpdate,
        'description': descriptionUpdate
      };
      await supabase.from('notes').update(data).eq('id', id);
      if (mounted) {
        Navigator.pop(context);
        _titleUpdate = false;
        _descriptionUpdate = false;
        Navigator.pop(context);
      }
    } catch (e) {
      context.showSnackBar(
          message: e.toString(),
          backgroundColor: Colors.red,
          icon: Icons.dangerous_outlined);
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
          .select('title , description, id')
          .eq('id_notes_user', idUser)
          .order('create_at', ascending: false);
    } catch (e) {
      if (e.toString().contains('ergjvwwsxxowhfbktrnj.supabase.co')) {
        context.showSnackBar(
            message: "Revise su conexión a Internet",
            backgroundColor: Colors.red,
            icon: Icons.dangerous_outlined);
      }
    }
    setState(() {
      _loadingNotes = false;
    });
    return data;
  }

  Future<void> _deleteNote(BuildContext context, String idUpdate) async {
    showLoaderDialog(context, 'Eliminando nota', 'images/lottie/delete.zip');
    try {
      String id = idUpdate.trim();
      await supabase.from('notes').delete().eq('id', id);
      if (mounted) {
        Navigator.pop(context);
        setState(() {
          _getNotes();
        });
      }
    } catch (e) {
      if (e.toString().contains('ergjvwwsxxowhfbktrnj.supabase.co')) {
        context.showSnackBar(
            message: "Revise su conexión a Internet",
            backgroundColor: Colors.red,
            icon: Icons.dangerous_outlined);
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
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

  Widget _showAnimateNote(BuildContext context, String titleUpdate,
      String descriptionUpdate, String idUpdate) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            key: _validateNoteUpdate,
            child: Column(children: [
              TextFormField(
                onChanged: (value) {
                  if (value != titleUpdate) {
                    setState(() {
                      _titleUpdate = true;
                      titleUpdate = value;
                    });
                  }
                },
                initialValue: titleUpdate,
                maxLines: 1,
                cursorColor: Colors.black,
                validator: (value) {
                  titleUpdate = value.toString();
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
                  if (value != descriptionUpdate) {
                    setState(() {
                      _descriptionUpdate = true;
                    });
                  }
                  return;
                },
                validator: (value) {
                  descriptionUpdate = value.toString();
                },
                initialValue: descriptionUpdate,
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
      ),
      actions: <Widget>[
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
          ),
          child: const Text(
            'Actualizar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_validateNoteUpdate.currentState!.validate()) {
              _updateNote(context, titleUpdate, descriptionUpdate, idUpdate);
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
            'Cerrar',
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
  }

  void _viewDeleteNote(String titleUpdate, String idUpdate) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimateDeleteNote(ctx, titleUpdate, idUpdate),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  Widget _showAnimateDeleteNote(
      BuildContext context, String titleUpdate, String idUpdate) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning_rounded,
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
              child: Text(titleUpdate),
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
            _deleteNote(context, idUpdate);
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
  }

  Future<void> _viewNote(BuildContext context, String titleUpdate,
      String descriptionUpdate, String idUpdate) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child:
              _showAnimateNote(ctx, titleUpdate, descriptionUpdate, idUpdate),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
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
        title: const Text(
          'Notas',
        ),
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
      body: Container(
          color: Colors.grey.withOpacity(0.2),
          child: (_loadingNotes == false)
              ? (data.isEmpty)
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No tiene notas creadas'),
                            Lottie.asset('images/lottie/empty.zip', repeat: false),
                            const Divider(
                                height: 50,
                                color: Colors.grey,
                                thickness: 1,
                                endIndent: 20,
                                indent: 20),
                            const Text(
                                'Puede crear su primera nota en esta parte'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Lottie.asset(
                                  'images/lottie/arrowdown.zip',
                                  height: 150,
                                  width: 150,
                                ),
                              ],
                            ),
                          ]),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5.0,
                            ),
                            Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50)),
                                    onPressed: (context) {
                                      _newTitleUpdate = data[index]['title'];
                                      _newIdNoteUpdate = data[index]['id'];
                                      _viewDeleteNote(
                                          _newTitleUpdate, _newIdNoteUpdate);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Eliminar',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      // ignore: prefer_interpolation_to_compose_strings
                                      Share.share('*' +
                                          data[index]['title']
                                              .toString()
                                              .trimRight() +
                                          '*' +
                                          '\n' +
                                          data[index]['description']);
                                    },
                                    backgroundColor: Colors.lightBlue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.share,
                                    label: 'Compartir',
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(50),
                                      topRight: Radius.circular(50)),
                                ),
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.swipe_right_outlined),
                                  onLongPress: () {
                                    //agregar para ver la fecha de creacion de nota
                                  },
                                  onTap: () {
                                    _newTitleUpdate = data[index]['title'];
                                    _newDescriptionUpdate =
                                        data[index]['description'];
                                    _newIdNoteUpdate = data[index]['id'];
                                    _viewNote(
                                        context,
                                        _newTitleUpdate,
                                        _newDescriptionUpdate,
                                        _newIdNoteUpdate);
                                  },
                                  minVerticalPadding: 10,
                                  title: Text(
                                    '${data[index]['title']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle:
                                      Text('${data[index]['description']}'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            )
                          ],
                        );
                      },
                    )
              : Center(
                  child: Lottie.asset('images/lottie/searching.zip',
                      width: 300, height: 300, fit: BoxFit.fill),
                )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.transparent,
              transitionAnimationController: AnimationController(
                  vsync: this, duration: const Duration(milliseconds: 400)),
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
