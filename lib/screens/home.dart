import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteif/helper/utils.dart';
import 'package:noteif/providers/note.dart';
import 'package:noteif/screens/add_note.dart';
import 'package:noteif/widgets/header.dart';
import 'package:noteif/widgets/notes_list.dart';
import 'package:noteif/widgets/theme_mode_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    final descriptionText = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Text(
        'ثبت یادداشت های مهم شما در نوتیفیکیشن :)',
        style: TextStyle(
          height: 1.7,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.center,
      ),
    );


    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              HeaderWidget(),
              descriptionText,
              Expanded(
                child: NotesListWidget(),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ThemeModeSettings(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _awaitReturnValueFromAddNoteScreen(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _awaitReturnValueFromAddNoteScreen(BuildContext context) async {
    Note _note = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNoteScreen(),
        ));
    if(_note != null){
      if (AppUtils.isAndroidOrIOS()) {
        AppUtils.sendNotification(_note);
      }
    }
  }

}
