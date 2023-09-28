import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:renamer/tools/ex_file.dart';
import 'package:renamer/tools/metadata_parser.dart';

Future<File?> rename(
  File file,
  FutureOr<String> Function(String name, MetadataParser parser) getNewName, {
  BuildContext? context,
}) async {
  try {
    // get file name
    String fileName = file.name;

    // get the directory
    final String directory = file.directory;

    final parser = MetadataParser(file);

    // new filename
    String newFileName = await getNewName.call(fileName, parser);

    newFileName = replaceSpecialCharacters(newFileName);

    // join the new filename
    final String newFilePath = path.join(directory, newFileName);

    return await file.rename(newFilePath);
  } catch (e, s) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: s);
    if (context != null && context.mounted) {
      showDialog(
        context: context,
        builder: (dContext) => AlertDialog(
          title: const Text('Renamer error'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.error_rounded),
                title: const Text('Error details'),
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
              const ListTile(
                title: Text(
                  'If files does not shown in file list, please clear all and continue.',
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
  input = input.replaceAll(':', '꞉');
  input = input.replaceAll('*', '＊');
  input = input.replaceAll('?', '﹖');
  input = input.replaceAll('"', "''");
  input = input.replaceAll('<', '〈');
  input = input.replaceAll('>', '〉');
  input = input.replaceAll('|', 'ǀ');
  return input;
}