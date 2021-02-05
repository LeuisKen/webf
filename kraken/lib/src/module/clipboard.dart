import 'package:flutter/services.dart';
import 'package:kraken/src/module/module_manager.dart';

class ClipBoardModule extends BaseModule {
  ClipBoardModule(ModuleManager moduleManager) : super(moduleManager);

  static Future<String> readText() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    return data.text;
  }

  static Future<void> writeText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  void dispose() {}

  @override
  String invoke(String method, dynamic params, callback) {
    if (method == 'readText') {
      ClipBoardModule.readText().then((String value) {
        callback(data: value ?? '');
      }).catchError((e, stack) {
        callback(errmsg: '$e\n$stack');
      });
    } else if (method == 'writeText') {
      List methodArgs = params[2];
      ClipBoardModule.writeText(methodArgs[0]).then((_) {
        callback();
      }).catchError((e, stack) {
        callback(errmsg: '');
      });
    }
    return '';
  }
}
