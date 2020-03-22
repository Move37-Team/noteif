import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noteif/helper/colors.dart';

Widget emptyAppbar() {
  return GradientAppBar(
    flexibleSpace: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomPaint(
          painter: CircleOne(),
        ),
        CustomPaint(
          painter: CircleTwo(),
        ),
      ],
    ),
    title: Center(child: Text('Noteif')),
    elevation: 0,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.HeaderBlueDark, AppColors.HeaderBlueLight],
    ),
  );
}

class CircleOne extends CustomPainter {
  Paint _paint;

  CircleOne() {
    _paint = Paint()
      ..color = AppColors.HeaderCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(28.0, 0.0), 99.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CircleTwo extends CustomPainter {
  Paint _paint;

  CircleTwo() {
    _paint = Paint()
      ..color = AppColors.HeaderCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(-30, 20), 50.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale("fa", "IR"),
    ],
    locale: Locale("fa", "IR"),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    myController.text = payload;
//    showDialog(
//      context: context,
//      builder: (_) => new AlertDialog(
//        title: new Text('Notification'),
//        content: new Text('$payload'),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: TextField(
                minLines: 3,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                  labelText: "متن یادداشت",
//                labelStyle: TextStyle(
//                  color: Colors.red
//                ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: myController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[

                  materialButton(
                      'ثبت',
                      showNotification,
                      LinearGradient(
                        colors: <Color>[
                          AppColors.Viking,
                          AppColors.ElfGreen,
                        ],
                      )),

                  materialButton(
                      'حذف نوتیفیکیشن',
                          () {flutterLocalNotificationsPlugin.cancel(0);},
                      LinearGradient(
                        colors: <Color>[
                          AppColors.BlueDark,
                          AppColors.HeaderBlueDark,
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        playSound: false,
        style: AndroidNotificationStyle.BigText,
        autoCancel: false,
        priority: Priority.High, importance: Importance.Max, ongoing: true);
    var iOS = new IOSNotificationDetails(presentSound: false);
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, null, myController.text, platform,
        payload: myController.text);
  }

  materialButton(String buttonText, void Function() param1, LinearGradient linearGradient) {
    return
      Expanded(
        flex: 1,
        child: Container(
          height: 45,
          margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          decoration: BoxDecoration(
            gradient: linearGradient,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.BlueShadow,
                blurRadius: 3.0,
                spreadRadius: 1.0,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: param1,
              child: Center(
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
        ),
      );
  }
}
