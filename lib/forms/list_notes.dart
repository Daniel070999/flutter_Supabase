import 'package:flutter/material.dart';

class ListNotes extends StatelessWidget {
  final List<ListItem> items;

  const ListNotes({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          minVerticalPadding: 10,
          onTap: () {},
          title: item.buildTitle(context),
          subtitle: item.buildSubtitle(context),
        );
      },
    );
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

class DataNotes implements ListItem {
  final String title;
  final String description;

  DataNotes(this.title, this.description);

  @override
  Widget buildTitle(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleLarge);

  @override
  Widget buildSubtitle(BuildContext context) =>
      Text(description, style: Theme.of(context).textTheme.caption);
}
