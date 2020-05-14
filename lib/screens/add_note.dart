import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noteif/helper/colors.dart';
import 'package:noteif/helper/utils.dart';
import 'package:noteif/models/note.dart';
import 'package:noteif/providers/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noteif/providers/theme_mode_changer.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  static const routeName = '/note/add';

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final noteBodyTextBoxController = TextEditingController();
  final noteTitleTextBoxController = TextEditingController();
  bool showNotification = false;
  SharedPreferences prefs;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    noteBodyTextBoxController.dispose();
    noteTitleTextBoxController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (AppUtils.isAndroidOrIOS()) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var android = AndroidInitializationSettings('@mipmap/notification_icon');
      var iOS = IOSInitializationSettings();
      var initSettings = InitializationSettings(android, iOS);
      flutterLocalNotificationsPlugin.initialize(
        initSettings,
        //        onSelectNotification: onSelectNotification
      );
    }
  }

//  Future onSelectNotification(String payload) {
//    debugPrint("payload : $payload");
//    myController.text = payload;
//    showDialog(
//      context: context,
//      builder: (_) => new AlertDialog(
//        title: new Text('Notification'),
//        content: new Text('$payload'),
//      ),
//    );
//  }

  void saveNote(BuildContext context) async {
    var notesProvider = Provider.of<NotesProvider>(context, listen: false);
    await notesProvider.insertNote(Note(
        body: noteBodyTextBoxController.text.trim(),
        title: noteBodyTextBoxController.text.trim()
    ));
    await notesProvider.getAllNotes();
    List<Note> notes = notesProvider.notes;
    if(notes.length > 0){
      print(notes.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    saveNote(context);
    ThemeModeChanger _themeModeChanger = Provider.of<ThemeModeChanger>(context);

    final noteTextBox = Container(
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

    final noteTextField = Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
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

    final showNotificationWidgets = Container(
      padding: const EdgeInsets.all(10.0),
      width: 300.0,
      child: MergeSemantics(
        child: ListTile(
          title: Text(
            'نمایش دادن نوتیفیکیشن',
            style: TextStyle(fontSize: 14.0),
          ),
          trailing: CupertinoSwitch(
            activeColor: AppColors.Viking,
            value: showNotification,
            onChanged: (val) => onSwitchChange(val),
          ),
          onTap: () => onSwitchChange(!showNotification),
        ),
      ),
    );
    final saveNoteButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Center(child: materialButton('ثبت یادداشت', setNote)),
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
                noteTextBox,
                noteTextField,
                saveNoteButton,
                showNotificationWidgets,
                themeModeSetting,
              ],
            ),
          ),
        ),
      ),
    );
  }

  setNote(){
    prefs.setBool('showNotification', true);
    prefs.setString('note', noteBodyTextBoxController.text.trim());
    if (AppUtils.isAndroidOrIOS()) {
      sendNotification(noteBodyTextBoxController.text.trim());
    }
  }

  disableNote() {
    setState(() {
      showNotification = false;
    });
    prefs.setBool('show', false);
    if (AppUtils.isAndroidOrIOS()) {
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  sendNotification(String notificationText) async {
    if (notificationText.isNotEmpty) {
      var android = AndroidNotificationDetails('note', 'note', 'Your note',
          playSound: false,
          enableVibration: false,
          styleInformation: BigTextStyleInformation(notificationText),
          autoCancel: false,
          priority: Priority.Max,
          importance: Importance.Max,
          ongoing: true);
      var iOS = IOSNotificationDetails(presentSound: false);
      var platform = NotificationDetails(android, iOS);
      await flutterLocalNotificationsPlugin
          .show(0, null, notificationText, platform, payload: notificationText);
    } else {
      // disableNote();
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

  onSwitchChange(bool val) {
    if (val) {
      setNote();
    } else {
      disableNote();
    }
  }
}
