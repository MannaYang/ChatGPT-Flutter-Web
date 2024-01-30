import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceProvider {
  static bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  static bool get isWeb => kIsWeb;

  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isWindows => !kIsWeb && Platform.isWindows;

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static bool get isLinux => !kIsWeb && Platform.isLinux;

  static bool get isMobile => isAndroid || isIOS;
}
