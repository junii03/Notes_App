import 'package:flutter/material.dart';

class NoteSettings extends StatelessWidget {
  final void Function() onEditPressed;
  final void Function() onDeletePressed;

  const NoteSettings(
      {super.key, required this.onEditPressed, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            onEditPressed();
          },
          icon: Icon(
            Icons.edit_note_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            onDeletePressed();
          },
          icon: Icon(
            Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
