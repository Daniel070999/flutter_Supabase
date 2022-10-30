import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttersupabase/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListNotes extends StatelessWidget {
  final List<ListItem> items;

  ListNotes({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            ListTile(
              minVerticalPadding: 10,
              onTap: () {
                context.showSnackBar(message: item.buildIdNote(context).data.toString(), backgroundColor: Colors.grey);
              },
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            ),
          ],
        );
      },
    );
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
  Text buildIdNote(BuildContext context);
}

class DataNotes implements ListItem {
  final String title;
  final String description;
  final String idNote;

  DataNotes(this.title, this.description, this.idNote);

  @override
  Widget buildTitle(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleLarge);

  @override
  Widget buildSubtitle(BuildContext context) =>
      Text(description, style: Theme.of(context).textTheme.caption);
  @override
  Text buildIdNote(BuildContext context) =>
      Text(idNote, style: Theme.of(context).textTheme.caption);
}
