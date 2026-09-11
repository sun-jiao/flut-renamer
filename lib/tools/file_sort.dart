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
        ? _compareNumericRuns(leftPart, rightPart)
        : leftPart.compareTo(rightPart);
    if (comparison != 0) return comparison;
  }

  return leftParts.length.compareTo(rightParts.length);
}

/// Compares decimal strings without converting them to a native integer.
///
/// File names may contain numeric runs that exceed Dart's integer range.
/// Removing leading zeroes first makes length a reliable magnitude comparison;
/// equal-length runs can then be compared lexicographically.
int _compareNumericRuns(String left, String right) {
  final normalizedLeft = left.replaceFirst(RegExp('^0+'), '');
  final normalizedRight = right.replaceFirst(RegExp('^0+'), '');
  final leftValue = normalizedLeft.isEmpty ? '0' : normalizedLeft;
  final rightValue = normalizedRight.isEmpty ? '0' : normalizedRight;

  final lengthComparison = leftValue.length.compareTo(rightValue.length);
  if (lengthComparison != 0) return lengthComparison;

  return leftValue.compareTo(rightValue);
}

/// Loads size and modification-time values before a size/date sort.
///
/// A small worker pool keeps a very large selection from opening an
/// unbounded number of file-system requests at once. [compareFiles] only
/// reads the values cached by this function; it never performs I/O.
Future<void> preloadFileSortMetadata(Iterable<FileEntity> files) async {
  final pending = files.toList(growable: false);
  const maxConcurrentLoads = 8;
  final workerCount =
      pending.length < maxConcurrentLoads ? pending.length : maxConcurrentLoads;
  var nextIndex = 0;

  Future<void> loadNext() async {
    while (nextIndex < pending.length) {
      final file = pending[nextIndex++];
      await file.preloadSortMetadata();
    }
  }

  await Future.wait(
    List<Future<void>>.generate(workerCount, (_) => loadNext()),
  );
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
    FileSortField.size =>
      _metadataValue(left, right, (metadata) => metadata.size),
    FileSortField.date => _metadataValue(
        left,
        right,
        (metadata) => metadata.modified?.millisecondsSinceEpoch,
      ),
  };

  if (comparison != 0) {
    return comparison;
  }

  return compareNaturally(left.name, right.name);
}

int _metadataValue(
  FileEntity left,
  FileEntity right,
  int? Function(FileSortMetadata metadata) value,
) {
  final leftMetadata = left.sortMetadata;
  final rightMetadata = right.sortMetadata;
  if (leftMetadata == null || rightMetadata == null) return 0;

  final leftValue = value(leftMetadata);
  final rightValue = value(rightMetadata);
  if (leftValue == null || rightValue == null) return 0;
  return leftValue.compareTo(rightValue);
}
