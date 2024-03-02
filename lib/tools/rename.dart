import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renamer/tools/ios_platform.dart';

import '../l10n/l10n.dart';
import '../tools/ex_file.dart';
import '../widget/custom_dialog.dart';

Future<FileSystemEntity?> rename(
  FileSystemEntity file, {
  BuildContext? context,
}) async {
  if (file.error) {
    return null;
  }

  if (file.name == file.newName) {
    return null;
  }

  try {
    file.newName = replaceSpecialCharacters(file.newName);
    if (Platform.isIOS) {
      final success = await PlatformFilePicker.renameFile(file.path, file.newPath);

      if (success) {
        return file.newPath.toFileSystemEntity();
      }
    }

    return await file.rename(file.newPath);
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
  }

  return null;
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
