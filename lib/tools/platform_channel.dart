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

  static Future<List<String>?> dirAccess() async {
    try {
      final result = await _channel.invokeMethod<dynamic>('dirAccess');
      if (result == null) return null;

      // Android returns the same `{paths, hasUnsupportedFiles}` map as the
      // document picker, while iOS returns its selected paths directly.
      if (result is Map) {
        return (result['paths'] as List?)?.whereType<String>().toList() ?? [];
      }
      if (result is List) {
        return result.whereType<String>().toList();
      }

      throw PlatformException(
        code: 'INVALID_DIRECTORY_RESULT',
        message: 'Unsupported directory picker result: ${result.runtimeType}',
      );
    } on PlatformException {
      // TODO: show error message dialog
      rethrow;
    }
  }

  static Future<List<String>?> fileAccess(
      BuildContext context, String startPath) async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'fileAccess',
        {
          'startPath': startPath,
        },
      );

      if (result == null) return null;

      final paths = (result['paths'] as List?)?.cast<String>() ?? [];
      final hasUnsupportedFiles =
          result['hasUnsupportedFiles'] as bool? ?? false;

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

  static Future<bool> changeScopedAccess(
      String targetPath, bool startOrEnd) async {
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

  /// Requests Android's one-time write confirmation for the selected media
  /// documents. Documents that support SAF rename are deliberately excluded by
  /// the Android implementation and don't show a confirmation dialog.
  static Future<MediaWritePermission> requestMediaWritePermission(
    Iterable<String> uris,
  ) async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'requestMediaWritePermission',
        {'uris': uris.toList()},
      );
      return MediaWritePermission.fromMap(result);
    } on PlatformException {
      return const MediaWritePermission.empty();
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

  static Future<Map<String, String>> getEmbeddedMetadata(String uri) async {
    try {
      final metadata = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getEmbeddedMetadata',
        {'uri': uri},
      );
      return metadata?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
      ) ??
          const {};
    } on PlatformException {
      return const {};
    }
  }
}

class MediaWritePermission {
  const MediaWritePermission({
    required this.candidates,
    required this.approved,
  });

  const MediaWritePermission.empty()
      : candidates = const <String>{},
        approved = const <String>{};

  final Set<String> candidates;
  final Set<String> approved;

  factory MediaWritePermission.fromMap(Map<dynamic, dynamic>? map) {
    Set<String> valuesFor(String key) =>
        (map?[key] as List? ?? const []).whereType<String>().toSet();

    return MediaWritePermission(
      candidates: valuesFor('candidates'),
      approved: valuesFor('approved'),
    );
  }
}
