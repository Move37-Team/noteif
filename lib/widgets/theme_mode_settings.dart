import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteif/providers/theme_mode_changer.dart';
import 'package:provider/provider.dart';
import '../screens/lang_view.dart';

class ThemeModeSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeModeChanger _themeModeChanger =
        Provider.of<ThemeModeChanger>(context, listen: false);
    return Row(
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
        IconButton(
          icon: Icon(Icons.language),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => LanguageView(), fullscreenDialog: true),
            );
          },
        ),
      ],
    );
  }
}
