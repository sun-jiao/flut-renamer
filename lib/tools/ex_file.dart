import 'dart:io';

import 'package:flutter/material.dart';

import '../tools/file_metadata.dart';

class ExtFieldHandler<T> {
  final Map<String, T> _values = {};

  T? getValue(String path) => _values[path];

  void setValue(String path, T? value) {
    if (value != null) {
      _values[path] = value;
    } else {
      _values.remove(path);
    }
  }

  void clearValues() => _values.clear();
}

// an extension to control file list selection.
extension ExFile on File {
  // get file name
  String get name => path.substring(path.lastIndexOf('/') + 1);

  // get the directory
  String get directory => path.substring(0, path.lastIndexOf('/'));

  static final ExtFieldHandler<bool> _selectionHandler = ExtFieldHandler();
  bool get selected => _selectionHandler.getValue(path) ?? false;
  set selected(bool? val) => _selectionHandler.setValue(path, val);
  static void clearSelections() => _selectionHandler.clearValues();

  static final ExtFieldHandler<bool> _errorHandler = ExtFieldHandler();
  bool get error => _errorHandler.getValue(path) ?? false;
  set error(bool? val) => _errorHandler.setValue(path, val);
  static void clearErrors() => _errorHandler.clearValues();

  static final ExtFieldHandler<FileMetadata> _metadataHandler = ExtFieldHandler();
  FileMetadata? get parser => _metadataHandler.getValue(path);
  set parser(FileMetadata? metadata) => _metadataHandler.setValue(path, parser);
  static void clearParsers() => _metadataHandler.clearValues();

  String fileOrDir() {
    try {
      if (File(path).existsSync()) {
        return 'File';
      }
    } catch (e, s) {
      debugPrint('$e\r\n$s');
    }

    try {
      if (Directory(path).existsSync()) {
        return 'Dir';
      }
    } catch (e, s) {
      debugPrint('$e\r\n$s');
    }

    return 'Renamer'; // Meaningless String to not contained by `_type`
  }
}
