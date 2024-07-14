import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late SharedPreferences prefs;

  Future<bool> saveLocal(String key, Map value) async {
    // print("****************set local****************\n");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("$key $value");
    // printLocal();
    prefs.setString(key, jsonEncode(value));
    // printLocal();
    // print("**************set local end**************\n");
    return true;
  }

  void printLocal() async {
    print("***************print local***************\n");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> value = prefs.getKeys();
    print(value);
    for (var key in value) {
      print(prefs.getString(key));
    }

    print("*************print local end*************\n");
  }

  Future<Map<String, dynamic>> getLocal(String key) async {
    // print("****************get local****************\n");
    // printLocal();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(key) != null) {
      Map<String, dynamic> value = jsonDecode(prefs.getString(key)!);
      // print("**************get local end**************\n");
      return value;
    } else {
      return {};
    }
  }

  bool deleteLocal(String key) {
    try {
      prefs.remove(key);
      return true;
    } catch (exception) {
      return false;
    }
  }
}
