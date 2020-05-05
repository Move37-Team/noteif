import 'package:flutter/material.dart';

class ThemeModeChanger with ChangeNotifier{
  
  ThemeMode _themeMode;

  ThemeModeChanger(this._themeMode);

  getThemeMode() => _themeMode;
  setThemeMode(ThemeMode themeMode){
    _themeMode = themeMode;

    notifyListeners();
      
  }
}