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
  final TextEditingController searchController = TextEditingController();
  List<Notes> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    readNotes();
    searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    textController.dispose();
    searchController.dispose();
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
            context
                .read<NotesDatabase>()
                .addNote(textController.text)
                .then((_) {
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
              setState(() {
                textController.clear();
                filteredNotes = [];
                FocusScope.of(context).unfocus();
              }); // Rebuild the NotesPage
            });
          }
        },
      ),
    );
  }

  // Read notes
  void readNotes() {
    context.read<NotesDatabase>().fetchNotes().then((_) {
      setState(() {
        filteredNotes = [];
        FocusScope.of(context).unfocus();
      }); // Refresh the page after fetching notes
    });
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
                .updateNote(note.id, textController.text)
                .then((_) {
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
              setState(() {
                textController.clear();
                filteredNotes = [];
                FocusScope.of(context).unfocus();
              }); // Rebuild the NotesPage
            });
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
              Navigator.pop(context); // Close the dialog
              context.read<NotesDatabase>().deleteNote(id).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Note Deleted!',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    dismissDirection: DismissDirection.horizontal,
                  ),
                );

                setState(() {
                  filteredNotes = [];
                  FocusScope.of(context).unfocus();
                }); // Rebuild the NotesPage
              });
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

  // Filter notes based on search input
  void _filterNotes() {
    final query = searchController.text.toLowerCase();
    final notesDatabase = context.read<NotesDatabase>();
    setState(() {
      filteredNotes = notesDatabase.currentNotes
          .where((note) => note.text.toLowerCase().contains(query))
          .toList();
    });
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
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        maxLines: null,
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
    final List<Notes> currentNotes =
        filteredNotes.isEmpty ? notesDatabase.currentNotes : filteredNotes;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Notes',
            style: GoogleFonts.dmSerifText(
              fontSize: 30,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: readNotes,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 10,
          onPressed: createNote,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        drawer: const MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  autofocus: false,
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).colorScheme.primary),
                    hintText: 'Search Notes',
                    hintStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  cursorColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) => _filterNotes(),
                ),
              ),
              Expanded(
                child: currentNotes.isEmpty
                    ? Center(
                        child: Text(
                          searchController.text.isEmpty
                              ? 'No notes available'
                              : 'No notes found for the search query',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
