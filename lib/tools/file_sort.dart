import 'dart:io';

import 'package:path/path.dart' as p;

import 'ex_file.dart';

enum FileSortField { name, size, date, type }

/// Compares names in the order people normally expect: `file`, `file(2)`,
/// `file(10)` instead of lexicographic order, which puts `file` last.
int compareNaturally(String left, String right) {
  final leftParts = RegExp(r'\d+|\D+').allMatches(left.toLowerCase());
  final rightParts = RegExp(r'\d+|\D+').allMatches(right.toLowerCase());
  final length = leftParts.length < rightParts.length
      ? leftParts.length
      : rightParts.length;

  for (var index = 0; index < length; index++) {
    final leftPart = leftParts.elementAt(index).group(0)!;
    final rightPart = rightParts.elementAt(index).group(0)!;
    final leftIsNumber = RegExp(r'^\d+$').hasMatch(leftPart);
    final rightIsNumber = RegExp(r'^\d+$').hasMatch(rightPart);

    final comparison = leftIsNumber && rightIsNumber
        ? int.parse(leftPart).compareTo(int.parse(rightPart))
        : leftPart.compareTo(rightPart);
    if (comparison != 0) return comparison;
  }

  return leftParts.length.compareTo(rightParts.length);
}

int compareFiles(FileEntity left, FileEntity right, FileSortField field) {
  final comparison = switch (field) {
    FileSortField.name => compareNaturally(
        p.basenameWithoutExtension(left.name),
        p.basenameWithoutExtension(right.name),
      ),
    FileSortField.type => compareNaturally(
        p.extension(left.name),
        p.extension(right.name),
      ),
    FileSortField.size => _statValue(left, right, (stat) => stat.size),
    FileSortField.date => _statValue(
        left,
        right,
        (stat) => stat.modified.millisecondsSinceEpoch,
      ),
  };

  if (comparison != 0) {
    return comparison;
  }

  return compareNaturally(left.name, right.name);
}

int _statValue(
  FileEntity left,
  FileEntity right,
  int Function(FileStat stat) value,
) {
  final leftStat = _tryStat(left);
  final rightStat = _tryStat(right);
  if (leftStat == null || rightStat == null) return 0;
  return value(leftStat).compareTo(value(rightStat));
}

FileStat? _tryStat(FileEntity file) {
  try {
    return file.entity.statSync();
  } on FileSystemException {
    return null;
  }
}
