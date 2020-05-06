import 'dart:io';
import 'package:flutter/foundation.dart';

class AppUtils {
  static bool isAndroidOrIOS() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
}
