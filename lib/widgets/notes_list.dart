import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteif/helper/colors.dart';
import 'package:noteif/providers/notes.dart';
import 'package:noteif/widgets/note_list_item.dart';
import 'package:provider/provider.dart';

class NotesListWidget extends StatefulWidget {
  @override
  _NotesListWidgetState createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends State<NotesListWidget> {
  var _isLoading = true;
  NotesProvider _notesProvider;

  @override
  void didChangeDependencies() {
    _notesProvider = Provider.of<NotesProvider>(context, listen: false);
    if (_notesProvider.notes == null) {
      setState(() {
        _isLoading = true;
      });
      _notesProvider.readAllNotes().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _notes = Provider.of<NotesProvider>(context).notes;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ..._notes
                      .map(
                        (note) => ChangeNotifierProvider.value(
                          value: note,
                          child: NoteListItemWidget(),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          );
  }
}
