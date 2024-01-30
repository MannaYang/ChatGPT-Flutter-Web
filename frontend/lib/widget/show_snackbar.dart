import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackBar(String str) {
  if (str.isEmpty) return;
  final snackBar = SnackBar(
    content: Center(child: Text(str)),
    width: getWidth(),
    behavior: SnackBarBehavior.floating,
    //margin: const EdgeInsets.only(left: 16, bottom: 100, right: 16),
    duration: const Duration(seconds: 2),
  );
  scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  // ScaffoldMessenger.of(scaffoldMessengerKey.currentState?.context)
  //   ..hideCurrentSnackBar()
  //   ..showSnackBar();
}

double getWidth() {
  final width =
      MediaQuery.of(scaffoldMessengerKey.currentState!.context).size.width;
  if (width > 700) return width / 3;
  return width * 0.8;
}
