import 'dart:async';
import 'dart:convert';

import 'package:kraken/src/module/module_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsyncStorageModule extends BaseModule {
  static Future<SharedPreferences> _prefs;

  AsyncStorageModule(ModuleManager moduleManager) : super(moduleManager);

  /// Loads and parses the [SharedPreferences] for this app from disk.
  ///
  /// Because this is reading from disk, it shouldn't be awaited in
  /// performance-sensitive blocks.
  static Future<SharedPreferences> _getPrefs() {
    if (_prefs == null) _prefs = SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<bool> setItem(String key, String value) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.setString(key, value);
  }

  static Future<String> getItem(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.getString(key);
  }

  static Future<bool> removeItem(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.remove(key);
  }

  static Future<Set<String>> getAllKeys() async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.getKeys();
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.clear();
  }

  @override
  void dispose() {
  }

  @override
  String invoke(String method, dynamic args, InvokeModuleCallback callback) {
    switch (method) {
      case 'getItem':
        AsyncStorageModule.getItem(args).then((String value) {
          callback(data: value ?? '');
        }).catchError((e, stack) {
          callback(errmsg: '$e\n$stack');
        });
        break;
      case 'setItem':
        String key = args[0];
        String value = args[1];
        AsyncStorageModule.setItem(key, value).then((bool isSuccess) {
          callback(data: isSuccess.toString());
        }).catchError((e, stack) {
          callback(errmsg: 'Error: $e\n$stack');
        });
        break;
      case 'removeItem':
        AsyncStorageModule.removeItem(args).then((bool isSuccess) {
          callback(data: isSuccess.toString());
        }).catchError((e, stack) {
          callback(errmsg: 'Error: $e\n$stack');
        });
        break;
      case 'getAllKeys':
        AsyncStorageModule.getAllKeys().then((Set<String> set) {
          List<String> list = List.from(set);
          callback(data: jsonEncode(list));
        }).catchError((e, stack) {
          callback(errmsg: 'Error: $e\n$stack');
        });
        break;
      case 'clear':
        AsyncStorageModule.clear().then((bool isSuccess) {
          callback(data: isSuccess.toString());
        }).catchError((e, stack) {
          callback(errmsg: 'Error: $e\n$stack');
        });
        break;
      default:
        throw Exception('AsyncStorage: Unknown method $method');
    }

    return '';
  }
}
