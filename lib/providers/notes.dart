import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:noteif/helper/database.dart';
import 'package:noteif/providers/note.dart';
import 'package:sembast/sembast.dart';

class NotesProvider extends ChangeNotifier {
  static const String folderName = "Notes";
  static final notesFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  List<Note> _notes;

  List<Note> get notes {
    return _notes;
  }

  Future<Note> insertNote(Note note) async {
    var id = await notesFolder.add(await _db, note.toMap());
    note.id = id;
    _notes.add(note);
    notifyListeners();
    return note;
  }

  Future<Note> updateNote(Note note) async {
    final finder = Finder(filter: Filter.byKey(note.id));
    await notesFolder.update(await _db, note.toMap(), finder: finder);

    // In case we didn't update note object
    _notes.firstWhere((element) => element.id == note.id).updateFrom(note);

    notifyListeners();
    return note;
  }

  Future delete(Note note) async {
    final finder = Finder(filter: Filter.byKey(note.id));
    await notesFolder.delete(await _db, finder: finder);
    _notes.removeWhere((element) => element.id == note.id);
    notifyListeners();
  }

  Future<List<Note>> readAllNotes() async {
    final recordSnapshot = await notesFolder.find(await _db);
    _notes = recordSnapshot.map((snapshot) {
      final note = Note.fromMap(snapshot.value);
      note.id = snapshot.key;
      return note;
    }).toList();
    notifyListeners();

    return _notes;
  }
}
