import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

extension SelectX on XFile {
  static final List<String> _selection = [];

  bool get selected => _selection.contains(path);

  set selected(bool val) =>
      val ? _selection.add(path) : _selection.remove(path);

  static void clear() => _selection.clear();

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
