import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../entity/rule.dart';

XFile? rename(XFile xFile, Rule rule, {bool ignoreExtension = true}) {
  // files dir
  final String filePath = xFile.path;

  // get file name
  String fileName = xFile.name;

  String extension = '';

  if (ignoreExtension) {
    final lastIndex = fileName.lastIndexOf('.');

    extension = fileName.substring(lastIndex);
    fileName = fileName.substring(0, lastIndex);
  }

  // get the directory
  final String directory = filePath.substring(0, filePath.lastIndexOf('/'));

  // new filename
  final String newFileName = rule.call(fileName);

  // join the new filename
  final String newFilePath = path.join(directory, newFileName + extension);

  // rename the file
  final File file = File(filePath);
  file.rename(newFilePath).then((file) {
    return XFile(newFilePath, name: newFileName);
  }).catchError((e, s) {
    debugPrint('$e\r\n$s');
    return null;
  });

  return null;
}