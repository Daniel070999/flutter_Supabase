import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _validateTitle = GlobalKey<FormState>();
  final _validateNoteUpdate = GlobalKey<FormState>();
  final Codec<String, String> _stringToBase64 = utf8.fuse(base64);

  List<dynamic> _notesData = [];
  String _newTitleUpdate = '';
  String _newDescriptionUpdate = '';
  String _newIdNoteUpdate = '';
  bool _loadingNotes = false;
  bool _titleUpdate = false;
  bool _descriptionUpdate = false;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveNote(BuildContext context) async {
    Fluttertoast.showToast(
      msg: 'Guardando nota...',
      gravity: ToastGravity.CENTER,
    );
    try {
      final title = _stringToBase64.encode(_titleController.text);
      final description = _stringToBase64.encode(_descriptionController.text);
      final createAt = DateTime.now().toIso8601String();
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final payload = {
        'id_notes_user': userId,
        'create_at': createAt,
        'title': title,
        'description': description,
      };
      await supabase.from('notes').insert(payload);
      if (context.mounted) {
        Fluttertoast.showToast(msg: 'Nota creada');
        Navigator.pop(context);
      }
    } catch (e) {
      if (isNetworkError(e)) {
        Fluttertoast.showToast(
          msg: 'Revise su conexión a internet',
          backgroundColor: Colors.red,
        );
      } else {
        Fluttertoast.showToast(msg: 'Algo salió mal');
      }
    }
    if (mounted) {
      _titleController.clear();
      _descriptionController.clear();
      await getNotes();
    }
  }

  Future<void> _updateNote(
    BuildContext context,
    String titleUpdate,
    String descriptionUpdate,
    String idUpdate,
  ) async {
    showLoaderDialog(context, 'Actualizando nota', 'images/lottie/update.zip');
    try {
      final createAt = DateTime.now().toIso8601String();
      final payload = {
        'update_at': createAt,
        'title': _stringToBase64.encode(titleUpdate),
        'description': _stringToBase64.encode(descriptionUpdate),
      };
      await supabase.from('notes').update(payload).eq('id', idUpdate);
      if (context.mounted) {
        Navigator.pop(context);
        _titleUpdate = false;
        _descriptionUpdate = false;
        Fluttertoast.showToast(msg: 'Nota actualizada');
        Navigator.pop(context);
      }
    } catch (_) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      Fluttertoast.showToast(msg: 'Algo salió mal');
    }
    if (mounted) {
      _titleController.clear();
      _descriptionController.clear();
      await getNotes();
    }
  }

  Future<List<dynamic>> getNotes() async {
    setState(() {
      _loadingNotes = true;
    });
    try {
      final idUser = supabase.auth.currentUser?.id;
      if (idUser != null) {
        _notesData = await supabase
            .from('notes')
            .select('title , description, id')
            .eq('id_notes_user', idUser)
            .order('create_at', ascending: false);
      }
    } catch (e) {
      if (isNetworkError(e)) {
        Fluttertoast.showToast(
          msg: 'Revise su conexión a internet',
          backgroundColor: Colors.red,
        );
      }
    }
    if (mounted) {
      setState(() {
        _loadingNotes = false;
      });
    }
    return _notesData;
  }

  Future<void> _deleteNote(BuildContext context, String idUpdate) async {
    showLoaderDialog(context, 'Eliminando nota', 'images/lottie/delete.zip');
    try {
      final id = idUpdate.trim();
      await supabase.from('notes').delete().eq('id', id);
      if (context.mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Nota eliminada');
        Navigator.pop(context);
        await getNotes();
        return;
      }
    } catch (e) {
      if (isNetworkError(e)) {
        Fluttertoast.showToast(
          msg: 'Revise su conexión a internet',
          backgroundColor: Colors.red,
        );
      } else {
        Fluttertoast.showToast(msg: 'Algo salió mal');
      }
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _confirmNoUpdate(BuildContext context) async {
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
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          title: const Text(
            '¿Esta seguro que desea salir sin guardar los cambios?',
          ),
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.lightGreen),
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
                backgroundColor: WidgetStatePropertyAll(Colors.red),
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

  Widget _showAnimateNote(
    BuildContext context,
    String titleUpdate,
    String descriptionUpdate,
    String idUpdate,
  ) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            key: _validateNoteUpdate,
            child: Column(
              children: [
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
                    final text = value ?? '';
                    titleUpdate = text;
                    if (text.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  onChanged: (value) {
                    if (value != descriptionUpdate) {
                      setState(() {
                        _descriptionUpdate = true;
                      });
                    }
                  },
                  validator: (value) {
                    descriptionUpdate = value ?? '';
                    return null;
                  },
                  initialValue: descriptionUpdate,
                  maxLines: 10,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.lightGreen),
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
        const SizedBox(height: 20.0),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          child: const Text(
            'Cerrar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (!_titleUpdate && !_descriptionUpdate) {
              Navigator.of(context).pop();
            } else {
              _confirmNoUpdate(context);
            }
          },
        ),
      ],
    );
  }

  void _viewDeleteNote(String titleUpdate, String idUpdate) {
    showGeneralDialog<void>(
      context: context,
      pageBuilder: (ctx, a1, a2) => const SizedBox.shrink(),
      transitionBuilder: (ctx, a1, a2, child) {
        final curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimateDeleteNote(ctx, titleUpdate, idUpdate),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  Widget _showAnimateDeleteNote(
    BuildContext context,
    String titleUpdate,
    String idUpdate,
  ) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning_rounded,
        size: 50.0,
      ),
      iconColor: Colors.red,
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Center(
              child: Text('¿Desea eliminar la nota?'),
            ),
            const SizedBox(height: 10.0),
            Center(child: Text(titleUpdate)),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _deleteNote(context, idUpdate);
          },
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.grey),
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

  Future<void> _viewNote(
    BuildContext context,
    String titleUpdate,
    String descriptionUpdate,
    String idUpdate,
  ) async {
    await showGeneralDialog<void>(
      context: context,
      pageBuilder: (ctx, a1, a2) => const SizedBox.shrink(),
      transitionBuilder: (ctx, a1, a2, child) {
        final curve = Curves.fastOutSlowIn.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _showAnimateNote(
            ctx,
            titleUpdate,
            descriptionUpdate,
            idUpdate,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  Future<void> showButtomNewNote() async {
    final sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    try {
      await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        transitionAnimationController: sheetController,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo,
                  Colors.teal.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
            ),
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
                        if ((value ?? '').isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título',
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
                            color: Colors.white,
                            width: 2.0,
                          ),
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
                        labelText: 'Descripción',
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
                            color: Colors.white,
                            width: 2.0,
                          ),
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
                            fixedSize: WidgetStateProperty.all(
                              const Size.fromWidth(150),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              Colors.lightGreen,
                            ),
                            overlayColor: WidgetStateProperty.all(
                              Colors.lightGreen.shade200,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            side: WidgetStateProperty.all(
                              const BorderSide(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (_validateTitle.currentState!.validate()) {
                              _saveNote(context);
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        OutlinedButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all(
                              const Size.fromWidth(150),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              Colors.red,
                            ),
                            overlayColor: WidgetStateProperty.all(
                              Colors.red.shade200,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            side: WidgetStateProperty.all(
                              const BorderSide(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _titleController.clear();
                            _descriptionController.clear();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } finally {
      sheetController.dispose();
    }
  }

  Future<void> _refresh() async {
    await getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeSelect(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notas'),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: barColor()),
          ),
        ),
        body: Container(
          color: Colors.grey.withValues(alpha: 0.2),
          child: (!_loadingNotes)
              ? (_notesData.isEmpty)
                  ? Center(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('No tiene notas creadas'),
                                Lottie.asset(
                                  'images/lottie/empty.zip',
                                  repeat: false,
                                ),
                                const Divider(
                                  height: 50,
                                  color: Colors.grey,
                                  thickness: 1,
                                  endIndent: 20,
                                  indent: 20,
                                ),
                                const Text(
                                  'Puede crear su primera nota en esta parte',
                                ),
                                const SizedBox(height: 10),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: _notesData.length,
                        itemBuilder: (context, index) {
                          final item = _notesData[index];
                          final decodedTitle = _stringToBase64.decode(
                            item['title'].toString(),
                          );
                          final decodedDescription = _stringToBase64.decode(
                            item['description'].toString(),
                          );
                          final noteId = item['id'].toString();
                          return Column(
                            children: [
                              const SizedBox(height: 5.0),
                              Slidable(
                                key: ValueKey(noteId),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50),
                                      ),
                                      onPressed: (context) {
                                        _newTitleUpdate = decodedTitle;
                                        _newIdNoteUpdate = noteId;
                                        _viewDeleteNote(
                                          _newTitleUpdate,
                                          _newIdNoteUpdate,
                                        );
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Eliminar',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        Share.share(
                                          '*${decodedTitle.trimRight()}*\n$decodedDescription',
                                        );
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
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: const IconTheme(
                                      data: IconThemeData(color: Colors.grey),
                                      child: Icon(Icons.swipe_right_outlined),
                                    ),
                                    onTap: () {
                                      _newTitleUpdate = decodedTitle;
                                      _newDescriptionUpdate =
                                          decodedDescription;
                                      _newIdNoteUpdate = noteId;
                                      _viewNote(
                                        context,
                                        _newTitleUpdate,
                                        _newDescriptionUpdate,
                                        _newIdNoteUpdate,
                                      );
                                    },
                                    minVerticalPadding: 10,
                                    title: Text(decodedTitle),
                                    subtitle: Text(decodedDescription),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                            ],
                          );
                        },
                      ),
                    )
              : Center(
                  child: Lottie.asset(
                    'images/lottie/searching.zip',
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          overlayStyle: const ExpandableFabOverlayStyle(blur: 0),
          children: [
            FloatingActionButton.extended(
              heroTag: 'write_note_fab',
              onPressed: showButtomNewNote,
              icon: const Icon(Icons.text_snippet_outlined),
              label: const Text('Escribir'),
            ),
            FloatingActionButton.extended(
              heroTag: 'voice_note_fab',
              onPressed: () {
                speechToText(context);
              },
              icon: const Icon(Icons.keyboard_voice_outlined),
              label: const Text('Hablar'),
            ),
          ],
        ),
      ),
    );
  }
}
