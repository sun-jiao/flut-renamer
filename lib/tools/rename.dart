import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

Future<XFile?> rename(XFile xFile, String Function(String name) getNewName) async {
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

  try {
    await file.rename(newFilePath);
    return XFile(newFilePath, name: newFileName);
  } catch (e, s) {
    debugPrintStack(stackTrace: s);
  }

  return null;
}
