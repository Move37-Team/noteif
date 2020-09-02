import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noteif/providers/note.dart';

class AppUtils {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static bool isAndroidOrIOS() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  static initFlutterLocalNotificationsPlugin(){
    if (AppUtils.isAndroidOrIOS()) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var android = AndroidInitializationSettings('@mipmap/notification_icon');
      var iOS = IOSInitializationSettings();
      var initSettings = InitializationSettings(android, iOS);
      flutterLocalNotificationsPlugin.initialize(
        initSettings,
      );
    }
  }

  static sendNotification(Note note) async {
    var android = AndroidNotificationDetails('note', 'note', 'Your note',
        playSound: false,
        enableVibration: false,
        styleInformation: BigTextStyleInformation(note.body),
        autoCancel: false,
        priority: Priority.Max,
        importance: Importance.Max,
        ongoing: true);
    var iOS = IOSNotificationDetails(presentSound: false);
    var platform = NotificationDetails(android, iOS);
    await AppUtils.flutterLocalNotificationsPlugin
        .show(note.id, note.title, note.body, platform, payload: note.body);
  }

  static cancelNotification(Note note) async {
    await flutterLocalNotificationsPlugin.cancel(note.id);
  }
}
