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

  static Future<String> getRealPathFromURI(String uriPath) async {
    try {
      return await _channel.invokeMethod(
        'getRealPathFromURI',
        {
          'uri': uriPath,
        },
      );
    } on PlatformException {
      // TODO: show error message dialog
      rethrow;
    }
  }

  static Future<String?> rename(String uri, String newName) async {
    try {
      return await _channel.invokeMethod<String>(
        'rename',
        {
          'uri': uri,
          'newName': newName,
        },
      );
    } on PlatformException {
      // TODO: show error message dialog
      rethrow;
    }
  }

  static Future<Map<dynamic, dynamic>?> getMetaData(String uri) async {
    try {
      return await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getMetaData',
        {'uri': uri},
      );
    } on PlatformException {
      return null;
    }
  }

  static Future<Uint8List?> readFile(String uri) async {
    try {
      return await _channel.invokeMethod<Uint8List>(
        'readFile',
        {'uri': uri},
      );
    } on PlatformException {
      return null;
    }
  }
}
