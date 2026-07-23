import 'dart:io';

import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toastification/toastification.dart';

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

  static Future<List<String>?> fileAccess(BuildContext context, String startPath) async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'fileAccess',
        {
          'startPath': startPath,
        },
      );

      if (result == null) return null;

      final paths = (result['paths'] as List?)?.cast<String>() ?? [];
      final hasUnsupportedFiles = result['hasUnsupportedFiles'] as bool? ?? false;

      if (hasUnsupportedFiles && context.mounted) {
        if (Platform.isAndroid) {
          Fluttertoast.showToast(msg: L10n.current.addedFilesCannotRename);
        } else {
          toastification.show(
            context: context,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            title: Text(L10n.current.addedFilesCannotRename),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }
      }

      return paths;
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
