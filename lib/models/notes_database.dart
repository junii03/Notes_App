import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_application/models/notes.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase extends ChangeNotifier{
  static late Isar isar;

  // INITIALIZE THE DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NotesSchema], directory: dir.path);
  }

  // List of notes
  final List<Notes> currentNotes = [];

  // CREATE - a note and save in the db
  Future<void> addNote(String text) async {
    // create a new note object
    final newNote = Notes()..text = text;
    //  final newNote = Notes(); .. does this operation => newNote.text = text;

    // save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    // re-read notes to update
    fetchNotes();

  }

  // READ - notes from db
  Future<void> fetchNotes() async {
    // grab all notes from db
    List<Notes> fetchedNotes = await isar.notes.where().findAll();

    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // UPDATE - existing notes in db
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;

      // save to db
      await isar.writeTxn(() => isar.notes.put(existingNote));

      // re-read notes to update
      fetchNotes();
    }
  }

  //DELETE - existing notes from db
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));

    // re-read notes to update
    fetchNotes();
  }
}
