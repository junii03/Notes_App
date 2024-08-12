import 'package:flutter/material.dart';
import 'package:notes_application/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function() onEditPressed;
  final void Function() onDeletePressed;

  const NoteTile(
      {super.key,
      required this.text,
      required this.onEditPressed,
      required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Theme.of(context).colorScheme.secondary,
      elevation: 3,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: Builder(builder: (context) {
          return IconButton(
              onPressed: () => showPopover(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    width: 100,
                    height: 100,
                    arrowWidth: 10,
                    radius: 15,
                    context: context,
                    bodyBuilder: (context) => NoteSettings(
                      onEditPressed: () => onEditPressed(),
                      onDeletePressed: () => onDeletePressed(),
                    ),
                  ),
              icon: Icon(Icons.more_vert_rounded));
        }),
      ),
    );
  }
}
