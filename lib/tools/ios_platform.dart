import 'package:flutter/services.dart';

class PlatformFilePicker {
  static const MethodChannel _channel =
      MethodChannel('net.sunjiao.renamer/picker');

  static Future<List<Object?>?> dirAccess() async {
    try {
      return await _channel.invokeMethod('dirAccess');
    } on PlatformException {
      // TODO: show error message dialog
      rethrow;
    }
  }

  static Future<List<Object?>?> fileAccess(String startPath) async {
    try {
      return await _channel.invokeMethod(
        'fileAccess',
        {
          'startPath': startPath,
        },
      );
    } on PlatformException {
      // TODO: show error message dialog
      rethrow;
    }
  }

  static Future<bool> changeScopedAccess(String targetPath, bool startOrEnd) async {
    try {
      return await _channel.invokeMethod(
        'changeScopedAccess',
        {
          'targetPath': targetPath,
          'startOrEnd': startOrEnd,
        },
      );
    } on PlatformException {
      // TODO: show error message dialog
      rethrow;
    }
  }
}
