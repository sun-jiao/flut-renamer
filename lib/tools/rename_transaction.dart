import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

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
  final originalNames = files
      .map(
        (file) => file.path.startsWith('content://') && file.metadata != null
            ? file.metadata!.androidRealName
            : file.name,
      )
      .toList(growable: false);
  final finalNames = files.map((file) => file.newName).toList(growable: false);
  final completedSteps = <_CompletedRename>[];
  final temporaryIndexes = _temporaryIndexes(files);
  final renameOrder = _deepestPathsFirst(files);

  for (final index in renameOrder.where(temporaryIndexes.contains)) {
    final temporary = await _temporaryEntity(files[index], index);
    if (!await _performRename(
      index,
      temporary,
      files[index].name,
      current,
      completedSteps,
      // The operation checks context.mounted before showing UI.
      // ignore: use_build_context_synchronously
      context,
      operation,
    )) {
      // The operation checks context.mounted before showing UI.
      // ignore: use_build_context_synchronously
      await _rollback(current, completedSteps, context, operation);
      await _rescanLocalState(files, current);
      return RenameTransactionResult(entities: current, succeeded: false);
    }
  }

  for (final index in renameOrder) {
    final previousName = temporaryIndexes.contains(index)
        ? current[index].name
        : originalNames[index];
    current[index].newName = finalNames[index];
    if (!await _performRename(
      index,
      current[index],
      previousName,
      current,
      completedSteps,
      // The operation checks context.mounted before showing UI.
      // ignore: use_build_context_synchronously
      context,
      operation,
    )) {
      // The operation itself checks context.mounted before showing UI.
      // ignore: use_build_context_synchronously
      await _rollback(current, completedSteps, context, operation);
      await _rescanLocalState(files, current);
      return RenameTransactionResult(entities: current, succeeded: false);
    }
  }

  return RenameTransactionResult(entities: current, succeeded: true);
}

Future<bool> _performRename(
  int index,
  FileEntity file,
  String previousName,
  List<FileEntity> current,
  List<_CompletedRename> completedSteps,
  BuildContext? context,
  RenameOperation operation,
) async {
  FileEntity? renamed;
  try {
    renamed = await operation(file, context);
  } catch (_) {
    renamed = null;
  }
  if (renamed == null) return false;

  current[index] = renamed;
  if (file.entity is Directory && file.path != renamed.path) {
    _relocateDescendants(current, index, file.path, renamed.path);
  }
  if (!identical(renamed, file)) {
    completedSteps.add(_CompletedRename(index, previousName));
  }
  return true;
}

/// A directory move changes the paths of every selected descendant. Keep their
/// transaction entries in sync so later operations and rollback use the new
/// location as their source.
void _relocateDescendants(
  List<FileEntity> current,
  int renamedIndex,
  String oldDirectory,
  String newDirectory,
) {
  for (var index = 0; index < current.length; index++) {
    if (index == renamedIndex || !p.isWithin(oldDirectory, current[index].path)) {
      continue;
    }

    final relativePath = p.relative(current[index].path, from: oldDirectory);
    final relocatedPath = p.join(newDirectory, relativePath);
    final entity = current[index].entity is Directory
        ? Directory(relocatedPath)
        : File(relocatedPath);
    current[index] = FileEntity(entity, newName: current[index].newName);
  }
}

Future<void> _rollback(
  List<FileEntity> current,
  List<_CompletedRename> completedSteps,
  BuildContext? context,
  RenameOperation operation,
) async {
  for (final step in completedSteps.reversed) {
    final renamed = current[step.index];
    renamed.newName = step.previousName;
    try {
      final restored = await operation(renamed, context);
      if (restored != null) current[step.index] = restored;
    } catch (_) {
      // Continue rolling back the other entries, then rescan all local paths.
    }
  }
}

Set<int> _temporaryIndexes(List<FileEntity> files) {
  final localMoves = <int>[];
  final sourceKeys = <String>{};
  final targetKeys = <String>[];

  for (var index = 0; index < files.length; index++) {
    final file = files[index];
    if (file.path.startsWith('content://')) continue;

    final sourceKey = _pathKey(file.path);
    final targetKey = _pathKey(file.newPath);
    if (sourceKey == targetKey) continue;

    localMoves.add(index);
    sourceKeys.add(sourceKey);
    targetKeys.add(targetKey);
  }

  return {
    for (var moveIndex = 0; moveIndex < localMoves.length; moveIndex++)
      if (sourceKeys.contains(targetKeys[moveIndex])) localMoves[moveIndex],
  };
}

/// Descendants must be renamed before their selected directory ancestors.
/// Otherwise a directory rename invalidates the source path of a later child.
List<int> _deepestPathsFirst(List<FileEntity> files) {
  final indexes = List<int>.generate(files.length, (index) => index);
  indexes.sort((left, right) {
    final depthComparison = _pathDepth(files[right].path).compareTo(
      _pathDepth(files[left].path),
    );
    return depthComparison == 0 ? left.compareTo(right) : depthComparison;
  });
  return indexes;
}

int _pathDepth(String path) {
  if (path.startsWith('content://')) return 0;
  return p.split(p.normalize(path)).length;
}

Future<FileEntity> _temporaryEntity(FileEntity file, int index) async {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  var attempt = 0;
  while (true) {
    final name = '.${file.name}.renamer-tmp-$stamp-$index-$attempt';
    final path = '${file.directory}${Platform.pathSeparator}$name';
    if (await FileSystemEntity.type(path) == FileSystemEntityType.notFound) {
      return FileEntity(file.entity, newName: name);
    }
    attempt++;
  }
}

String _pathKey(String path) {
  final absolutePath = File(path).absolute.path;
  return Platform.isWindows || Platform.isMacOS || Platform.isIOS
      ? absolutePath.toLowerCase()
      : absolutePath;
}

class _CompletedRename {
  const _CompletedRename(this.index, this.previousName);

  final int index;
  final String previousName;
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
