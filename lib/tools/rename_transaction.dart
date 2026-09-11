import 'dart:io';

import 'package:flutter/widgets.dart';

import 'ex_file.dart';
import 'rename.dart';

typedef RenameOperation = Future<FileEntity?> Function(
  FileEntity file,
  BuildContext? context,
);

class RenameTransactionResult {
  const RenameTransactionResult({
    required this.entities,
    required this.succeeded,
  });

  /// The entity currently representing each input item, in input order.
  final List<FileEntity> entities;
  final bool succeeded;
}

/// Commits a preflighted rename plan and rolls completed moves back on failure.
///
/// Callers must perform collision and permission checks before invoking this
/// function. After a failed commit, local paths are probed again so the UI is
/// rebuilt from filesystem state even when a rollback itself fails.
Future<RenameTransactionResult> commitRenameTransaction(
  List<FileEntity> files, {
  BuildContext? context,
  RenameOperation operation = _renameOperation,
}) async {
  final current = List<FileEntity>.from(files);
  final completed = <int>[];
  final originalNames = files
      .map(
        (file) => file.path.startsWith('content://') && file.metadata != null
            ? file.metadata!.androidRealName
            : file.name,
      )
      .toList(growable: false);

  for (var index = 0; index < files.length; index++) {
    FileEntity? renamed;
    try {
      renamed = await operation(files[index], context);
    } catch (_) {
      renamed = null;
    }
    if (renamed == null) {
      // The operation itself checks context.mounted before showing UI.
      // ignore: use_build_context_synchronously
      await _rollback(originalNames, current, completed, context, operation);
      await _rescanLocalState(files, current);
      return RenameTransactionResult(entities: current, succeeded: false);
    }
    current[index] = renamed;
    if (!identical(renamed, files[index])) completed.add(index);
  }

  return RenameTransactionResult(entities: current, succeeded: true);
}

Future<void> _rollback(
  List<String> originalNames,
  List<FileEntity> current,
  List<int> completed,
  BuildContext? context,
  RenameOperation operation,
) async {
  for (final index in completed.reversed) {
    final renamed = current[index];
    renamed.newName = originalNames[index];
    try {
      final restored = await operation(renamed, context);
      if (restored != null) current[index] = restored;
    } catch (_) {
      // Continue rolling back the other entries, then rescan all local paths.
    }
  }
}

Future<void> _rescanLocalState(
  List<FileEntity> originals,
  List<FileEntity> current,
) async {
  for (var index = 0; index < originals.length; index++) {
    if (originals[index].path.startsWith('content://')) continue;

    final originalType = await FileSystemEntity.type(originals[index].path);
    if (originalType != FileSystemEntityType.notFound) {
      current[index] = FileEntity(
        _entityForType(
          originals[index].path,
          originalType,
        ),
      );
      continue;
    }

    final renamedType = await FileSystemEntity.type(current[index].path);
    if (renamedType != FileSystemEntityType.notFound) {
      current[index] = FileEntity(
        _entityForType(
          current[index].path,
          renamedType,
        ),
      );
    }
  }
}

FileSystemEntity _entityForType(String path, FileSystemEntityType type) =>
    type == FileSystemEntityType.directory ? Directory(path) : File(path);

Future<FileEntity?> _renameOperation(
  FileEntity file,
  BuildContext? context,
) =>
    rename(file, context: context);
