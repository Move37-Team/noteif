import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:noteif/helper/colors.dart';
import 'package:noteif/providers/notes.dart';
import 'package:noteif/providers/theme_mode_changer.dart';
import 'package:noteif/screens/home.dart';
import 'package:provider/provider.dart';

import 'package:noteif/helper/utils.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppUtils.initFlutterLocalNotificationsPlugin();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<NotesProvider>(
            create: (_) => NotesProvider(),
          ),
          ChangeNotifierProvider<ThemeModeChanger>(
            create: (_) => ThemeModeChanger(ThemeMode.system),
          ),
        ],
      child: MaterialAppWithThemeMode(),
    );
  }
}

class MaterialAppWithThemeMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeModeChanger>(context);

    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      supportedLocales: [
        Locale("fa", "IR"),
      ],
      theme: ThemeData(
        fontFamily: 'Vazir',
        primaryColor: AppColors.bondiBlue,
        scaffoldBackgroundColor: AppColors.whiteSmoke,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Vazir',
        brightness: Brightness.dark,
      ),
      themeMode: themeMode.getThemeMode(),
        locale: Locale("fa", "IR"),
//      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
      },
    );
  }
}
