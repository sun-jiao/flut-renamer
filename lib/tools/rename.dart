import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

Future<XFile?> rename(XFile xFile, String Function(String name) getNewName,
    {BuildContext? context,}) async {
  try {
    // files dir
    final String filePath = xFile.path;

    // get file name
    String fileName = xFile.name;

    String extension = '';

    // get the directory
    final String directory = filePath.substring(0, filePath.lastIndexOf('/'));

    // new filename
    final String newFileName = getNewName.call(fileName);

    // join the new filename
    final String newFilePath = path.join(directory, newFileName + extension);

    // rename the file
    final File file = File(filePath);

    await file.rename(newFilePath);
    return XFile(newFilePath, name: newFileName);
  } catch (e, s) {
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
                    await Clipboard.setData(ClipboardData(
                        text: s.toString(),),);

                    if (dContext.mounted) {
                      Navigator.pop(dContext);
                    }
                  },
                  icon: const Icon(Icons.copy),
                ),
                titleAlignment: ListTileTitleAlignment.titleHeight,
              ),
              const ListTile(
                title: Text('If files does not shown in file list, please clear all and continue.'),
              ),
            ],
          ),
        ),
      );
    }
  }

  return null;
}
