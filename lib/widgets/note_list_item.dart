import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noteif/helper/colors.dart';
import 'package:noteif/helper/utils.dart';
import 'package:noteif/providers/note.dart';
import 'package:noteif/providers/notes.dart';
import 'package:noteif/screens/create_update_note.dart';
import 'package:provider/provider.dart';

class NoteListItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _note = Provider.of<Note>(context);
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(7.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.noteListItemLight
            : Colors.white10,
      ),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _note.title != null
                        ? Text(
                            _note.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : SizedBox.shrink(),
                    Text(
                      _note.body,
                      style: TextStyle(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                activeColor: AppColors.Viking,
                value: _note.isEnabled == true,
                onChanged: (val) {
                  _note.setEnabled(val);
                  if (val) {
                    AppUtils.sendNotification(_note);
                  } else {
                    AppUtils.cancelNotification(_note);
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              buildNoteListItemIcon(
                Icons.mode_edit,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateUpdateNoteScreen(
                      note: _note,
                    ),
                  ),
                ),
              ),
              buildNoteListItemIcon(
                Icons.delete,
                Colors.redAccent,
                () {
                  var notesProvider =
                      Provider.of<NotesProvider>(context, listen: false);
                  notesProvider.delete(_note);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNoteListItemIcon(
      IconData iconData, Color backgroundColor, Function onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: ClipOval(
        child: Material(
          color: backgroundColor, // button color
          child: InkWell(
            // splashColor: Colors.red, // inkwell color
            child: SizedBox(
              width: 38,
              height: 38,
              child: Icon(
                iconData,
                color: Colors.white,
                size: 17.5,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(4.0, 4.0, 6.0, 3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Material(
        shape: CircleBorder(),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(7.0),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 17.5,
            ),
          ),
        ),
      ),
    );
  }
}
