import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteif/providers/notes.dart';
import 'package:noteif/providers/theme_mode_changer.dart';
import 'package:provider/provider.dart';

class ThemeModeSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeModeChanger _themeModeChanger = Provider.of<NotesProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

        ],
      ),
    );
  }
}
