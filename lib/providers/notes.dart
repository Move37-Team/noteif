import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:noteif/helper/database.dart';
import 'package:noteif/models/note.dart';
import 'package:sembast/sembast.dart';

class NotesProvider extends ChangeNotifier{
  static const String folderName = "Notes";
  List<Note> _notes;
  final _noteFolder = intMapStoreFactory.store(folderName);

  List<Note> get notes {
    return _notes;
  }

  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertNote(Note note) async{
    await  _noteFolder.add(await _db, note.toMap() );
    print('Note Inserted successfully !!');
  }

  Future updateNote(Note note) async{
    final finder = Finder(filter: Filter.byKey(note.id));
    await _noteFolder.update(await _db, note.toMap(),finder: finder);

  }


  Future delete(Note note) async{
    final finder = Finder(filter: Filter.byKey(note.id));
    await _noteFolder.delete(await _db, finder: finder);
  }

  void readAllNotes() async {
    final recordSnapshot = await _noteFolder.find(await _db);
    _notes = recordSnapshot.map((snapshot){
      final note = Note.fromMap(snapshot.value);
      return note;
    }).toList();
    notifyListeners();
  }

}