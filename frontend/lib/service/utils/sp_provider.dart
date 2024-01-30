import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SpProvider {
  SpProvider._internal();

  static final SpProvider _instance = SpProvider._internal();

  factory SpProvider() => _instance;

  static SharedPreferences? _prefs;

  late final prefsException =
      Exception('Please init SharedPreferences instance first!');

  Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> clear() {
    return _prefs == null ? Future.value(false) : _prefs!.clear();
  }

  bool checkIsNull(String? key) => (key == null || key.isEmpty);

  bool checkPrefsIsNull() => _prefs == null;

  double getDouble(String? key, {double defValue = 0.0}) {
    if (checkPrefsIsNull()) throw prefsException;
    if (checkIsNull(key)) return defValue;
    return _prefs?.getDouble(key!) ?? defValue;
  }

  Future<bool> setDouble(String key, double value) {
    if (checkPrefsIsNull()) throw prefsException;
    return _prefs!.setDouble(key, value);
  }

  int getInt(String? key, {int defValue = 0}) {
    if (checkPrefsIsNull()) throw prefsException;
    if (checkIsNull(key)) return defValue;
    return _prefs?.getInt(key!) ?? defValue;
  }

  Future<bool> setInt(String key, int value) {
    if (checkPrefsIsNull()) throw prefsException;
    return _prefs!.setInt(key, value);
  }

  String getString(String? key, {String defValue = ''}) {
    if (checkPrefsIsNull()) throw prefsException;
    if (checkIsNull(key)) return defValue;
    return _prefs?.getString(key!) ?? defValue;
  }

  Future<bool> setString(String key, String value) {
    if (checkPrefsIsNull()) throw prefsException;
    return _prefs!.setString(key, value);
  }

  bool getBool(String? key, {bool defValue = false}) {
    if (checkPrefsIsNull()) throw prefsException;
    if (checkIsNull(key)) return defValue;
    return _prefs?.getBool(key!) ?? defValue;
  }

  Future<bool> setBool(String key, bool value) {
    if (checkPrefsIsNull()) throw prefsException;
    return _prefs!.setBool(key, value);
  }
}
