import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

class ExtFieldHandler<T> {
  final List<T> _values = [];

  bool getValue(T item) => _values.contains(item);

  void setValue(T item, bool selected) {
    if (selected) {
      _values.add(item);
    } else {
      _values.remove(item);
    }
  }

  void clearValues() => _values.clear();
}

// an extension to control file list selection.
extension SelectX on XFile {
  static final ExtFieldHandler<String> _selectionHandler = ExtFieldHandler();
  static final ExtFieldHandler<String> _errorHandler = ExtFieldHandler();

  bool get selected => _selectionHandler.getValue(path);

  set selected(bool val) => _selectionHandler.setValue(path, val);

  static void clearSelections() => _selectionHandler.clearValues();

  bool get error => _errorHandler.getValue(path);

  set error(bool val) => _errorHandler.setValue(path, val);

  static void clearErrors() => _errorHandler.clearValues();

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

    return 'SunJiao'; // Meaningless String to not contained by `_type`
  }
}
