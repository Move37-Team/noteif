import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:noteif/helper/colors.dart';
import 'package:noteif/helper/utils.dart';
import 'package:noteif/providers/note.dart';
import 'package:noteif/providers/notes.dart';
import 'package:noteif/providers/theme_mode_changer.dart';
import 'package:provider/provider.dart';

class CreateUpdateNoteScreen extends StatefulWidget {
  static const routeName = '/note/add';
  final Note note;

  CreateUpdateNoteScreen({Key key, this.note}) : super(key: key);

  @override
  _CreateUpdateNoteScreenState createState() => _CreateUpdateNoteScreenState();
}

class _CreateUpdateNoteScreenState extends State<CreateUpdateNoteScreen> {
  final noteBodyTextBoxController = TextEditingController();
  final noteTitleTextBoxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteBodyTextBoxController.text =
        widget.note != null ? widget.note.body : '';
    noteTitleTextBoxController.text =
        widget.note != null ? widget.note.title : '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    noteBodyTextBoxController.dispose();
    noteTitleTextBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeModeChanger _themeModeChanger = Provider.of<ThemeModeChanger>(context);

    final headerWidget = Container(
      decoration: Theme.of(context).brightness == Brightness.light
          ? BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.veryLightGray, AppColors.whiteSmoke],
            ))
          : BoxDecoration(color: Colors.grey[850]),
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Noteif',
        style: TextStyle(
          fontFamily: 'Chewy',
          fontSize: 30.0,
        ),
        textAlign: TextAlign.center,
      ),
    );

    final noteTitleTextField = Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
      child: TextField(
        style: TextStyle(
          fontSize: 14.0,
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        cursorColor: AppColors.bondiBlue,
        decoration: new InputDecoration(
          labelText: "عنوان",
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(7.0),
          ),
        ),
        controller: noteTitleTextBoxController,
      ),
    );

    final noteBodyTextField = Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: TextField(
        style: TextStyle(
          fontSize: 14.0,
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        minLines: 6,
        cursorColor: AppColors.bondiBlue,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: new InputDecoration(
          labelText: "متن یادداشت",
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(7.0),
          ),
        ),
        controller: noteBodyTextBoxController,
      ),
    );

    final saveNoteButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child:
          Center(child: materialButton('ثبت یادداشت', () => saveNote(context))),
    );

    final themeModeSetting = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.brightness_auto),
          onPressed: () => _themeModeChanger.setThemeMode(ThemeMode.system),
        ),
        IconButton(
          icon: Icon(Icons.wb_sunny),
          onPressed: () => _themeModeChanger.setThemeMode(ThemeMode.light),
        ),
        IconButton(
          icon: Icon(Icons.brightness_2),
          onPressed: () => _themeModeChanger.setThemeMode(ThemeMode.dark),
        ),
      ],
    );

    return Scaffold(
//      appBar: emptyAppbar(),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                headerWidget,
                noteTitleTextField,
                noteBodyTextField,
                saveNoteButton,
                themeModeSetting,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveNote(BuildContext context) async {
    var _title = noteTitleTextBoxController.text.trim();
    var _body = noteBodyTextBoxController.text.trim();
    if (_body.isNotEmpty) {
      var notesProvider = Provider.of<NotesProvider>(context, listen: false);
      Note _note;
      if (widget.note == null) {
        // create note
        _note = Note(
          title: _title.isNotEmpty ? _title : null,
          body: _body,
          isEnabled: true,
        );
        _note = await notesProvider.insertNote(_note);
      } else {
        // update note
        _note = widget.note;
        _note.title = _title.isNotEmpty ? _title : null;
        _note.body = _body;
        _note = await notesProvider.updateNote(_note);
      }
      if (_note.isEnabled && AppUtils.isAndroidOrIOS()) {
        AppUtils.sendNotification(_note);
      }
      Navigator.pop(context);
    }
  }

  materialButton(String buttonText, void Function() onTap) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: AppColors.Viking,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 1.5,
            spreadRadius: 0.1,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
            child: Text(
              buttonText,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
