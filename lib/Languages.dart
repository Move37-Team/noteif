import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';




class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Pushing your important notes in notifications :)',
      'main':'Main Text',
      'button':'Record Note',
      'switch':'Show notification',
    },
    'fa': {
      'title':' ثبت یادداشت های مهم شما در نوتیفیکیشن :)',
      'main':'متن یادداشت',
      'button':'ثبت یادداشت',
      'switch':'نمایش نوتیفیکیشن'
      
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
  String get main {
    return _localizedValues[locale.languageCode]['main'];
  }
  String get button {
    return _localizedValues[locale.languageCode]['button'];
  }
  String get switchKey {
    return _localizedValues[locale.languageCode]['switch'];
  }
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fa'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}