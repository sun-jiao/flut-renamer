import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../tools/atomic_rename.dart';
import '../tools/ex_file.dart';
import '../widget/custom_dialog.dart';
import '../tools/platform_channel.dart';
import '../tools/logger.dart';

Future<FileEntity?> rename(
  FileEntity file, {
  BuildContext? context,
}) async {
  if (file.error != null) {
    return file;
  }

  final isAndroidUri = Platform.isAndroid && file.path.startsWith('content://');
  if (isAndroidUri) {
    await file.initMetadata();
    if (file.metadata!.androidRealName == file.newName) {
      return file;
    }
  } else if (file.name == file.newName) {
    return file;
  }

  try {
    file.newName = replaceSpecialCharacters(file.newName);
    if (isAndroidUri) {
      final newUriString =
          await PlatformFilePicker.rename(file.path, file.newName);
      if (newUriString != null) {
        // SAF URIs do not encode whether the selected document is a file or
        // directory. Keep the original entity type so directory rows remain
        // visible when the active filter is "Directories" after a rename.
        final renamedEntity = file.entity is Directory
            ? Directory(newUriString)
            : File(newUriString);
        final newFileEntity = FileEntity(renamedEntity);
        newFileEntity.selected = file.selected;
        _logRename(file.path, newUriString);
        return newFileEntity;
      } else {
        throw FileSystemException("SAF rename returned null for ${file.path}");
      }
    } else {
      final renamedEntity = await atomicRenameNoReplace(
        file.entity,
        file.newPath,
      );
      _logRename(file.path, renamedEntity.path);
      return FileEntity(renamedEntity);
    }
  } catch (e, s) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: s);
    if (context != null && context.mounted) {
      showDialog(
        context: context,
        builder: (dContext) => CustomDialog(
          title: Text(L10n.current.appError),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.error_rounded),
                title: Text(L10n.current.errorDetails + e.toString()),
                subtitle: Text(s.toString()),
                trailing: IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: s.toString(),
                      ),
                    );

                    if (dContext.mounted) {
                      Navigator.pop(dContext);
                    }
                  },
                  icon: const Icon(Icons.copy),
                ),
                titleAlignment: ListTileTitleAlignment.titleHeight,
              ),
              ListTile(
                title: Text(
                  L10n.current.ifFileNotShown,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return null;
  }
}

/// Logging is best-effort: a successful filesystem rename must not be
/// presented to the user as a failure merely because its audit entry failed.
void _logRename(String oldPath, String newPath) {
  unawaited(
    Logger()
        .logRename(oldPath, newPath)
        .catchError((Object error, StackTrace stackTrace) {
      debugPrint('Failed to write rename log: $error');
      debugPrintStack(stackTrace: stackTrace);
    }),
  );
}

String replaceSpecialCharacters(String input) {
  input = input.replaceAll(r'\', '⧵');
  input = input.replaceAll('/', '∕');
  input = input.replaceAll(':', '∶');
  input = input.replaceAll('*', '＊');
  input = input.replaceAll('?', '﹖');
  input = input.replaceAll('"', "''");
  input = input.replaceAll('<', '〈');
  input = input.replaceAll('>', '〉');
  input = input.replaceAll('|', 'ǀ');
  return input;
}
