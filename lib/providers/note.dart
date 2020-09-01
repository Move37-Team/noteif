import 'package:flutter/foundation.dart';
import 'package:noteif/helper/database.dart';
import 'package:noteif/providers/notes.dart';
import 'package:sembast/sembast.dart';

class Note with ChangeNotifier {
  int id;
  String title;
  String body;
  bool isEnabled;

  Future<Database> get _db async => await AppDatabase.instance.database;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'enabled': isEnabled
    };
    return map;
  }

  Note({this.id, this.title, this.body, this.isEnabled});

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    isEnabled = map['enabled'];
  }

  void setEnabled(value) {
    isEnabled = value;
    this.updateNote();
    notifyListeners();
  }


  Future updateNote() async {
    final finder = Finder(filter: Filter.byKey(this.id));
    await NotesProvider.notesFolder.update(await _db, this.toMap(), finder: finder);
  }
}
