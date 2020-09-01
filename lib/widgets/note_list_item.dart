import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noteif/helper/colors.dart';
import 'package:noteif/helper/utils.dart';
import 'package:noteif/providers/note.dart';
import 'package:provider/provider.dart';

class NoteListItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _note = Provider.of<Note>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? AppColors.noteListItemLight : Colors.white10,
      ),
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _note.title != null ? _note.title : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _note.body,
                    style: TextStyle(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoSwitch(
            activeColor: AppColors.Viking,
            value: _note.isEnabled == true,
            onChanged: (val) {
              _note.setEnabled(val);
              if(val){
                AppUtils.sendNotification(_note);
              } else {
                AppUtils.cancelNotification(_note);
              }
            },
          ),
        ],
      ),
    );
  }
}
