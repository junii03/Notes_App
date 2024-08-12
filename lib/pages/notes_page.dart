import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_application/components/drawer.dart';
import 'package:notes_application/components/note_tile.dart';
import 'package:notes_application/models/notes.dart';
import 'package:notes_application/models/notes_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Create a note
  void createNote() {
    textController
        .clear(); // Ensure the field is empty when creating a new note
    showDialog(
      context: context,
      builder: (context) => buildNoteDialog(
        title: 'New Note',
        onSubmit: () {
          if (textController.text.isNotEmpty) {
            context.read<NotesDatabase>().addNote(textController.text);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Note Created!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                dismissDirection: DismissDirection.horizontal,
              ),
            );
          }
        },
      ),
    );
  }

  // Read notes
  void readNotes() {
    context.read<NotesDatabase>().fetchNotes();
  }

  // Update a note
  void updateNote(Notes note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => buildNoteDialog(
        title: 'Update Note',
        onSubmit: () {
          if (textController.text.isNotEmpty) {
            context
                .read<NotesDatabase>()
                .updateNote(note.id, textController.text);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Note Updated!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                dismissDirection: DismissDirection.horizontal,
              ),
            );
          }
        },
      ),
    );
  }

  // Delete a note
  void deleteNote(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Delete Note',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this note?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // User confirmed, delete the note
              context.read<NotesDatabase>().deleteNote(id);
              Navigator.pop(context); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Note Deleted!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  dismissDirection: DismissDirection.horizontal,
                ),
              );
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog without deleting
            },
            child: Text(
              'No',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoteDialog(
      {required String title, required VoidCallback onSubmit}) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter Your Note',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            textController.clear();
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        TextButton(
          onPressed: onSubmit,
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesDatabase = context.watch<NotesDatabase>();
    final List<Notes> currentNotes = notesDatabase.currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 10,
        onPressed: createNote,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 45,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),

          // Body
          Expanded(
            child: Stack(
              children: [
                // background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.scaleDown,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                    colorBlendMode: BlendMode.modulate,
                  ),
                ),
                // content
                ListView.builder(
                  itemCount: currentNotes.length,
                  itemBuilder: (context, index) {
                    final note = currentNotes[index];
                    return NoteTile(
                      text: note.text,
                      onEditPressed: () => updateNote(note),
                      onDeletePressed: () => deleteNote(note.id),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
