import 'package:flutter/services.dart';

class PlatformFilePicker {
  static const MethodChannel _channel = MethodChannel('net.sunjiao.renamer/picker');

  static Future<void> dirAccess() async {
    try {
      await _channel.invokeMethod('dirAccess');
    } on PlatformException catch (e) {
      // show error message
    }
  }

  static Future<void> renameFile() async {
    try {
      await _channel.invokeMethod('renameFile');
    } on PlatformException catch (e) {
      // show error message
    }
  }
}
