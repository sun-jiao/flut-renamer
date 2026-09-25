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
    this.directoryMoves = const [],
  });

  /// The entity currently representing each input item, in input order.
  final List<FileEntity> entities;
  final bool succeeded;

  /// Successful moves in execution order, including staging and rollback.
  final List<DirectoryMove> directoryMoves;

  /// Updates an entry that did not participate in the transaction.
  FileEntity relocateDescendant(FileEntity file) {
    for (final move in directoryMoves) {
      file = move.relocate(file);
    }
    return file;
  }
}

class DirectoryMove {
  const DirectoryMove(this.source, this.destination);

  final String source;
  final String destination;

  FileEntity relocate(FileEntity file) {
    if (file.path.startsWith('content://') || !p.isWithin(source, file.path)) {
      return file;
    }
    return file.withPath(
      p.join(destination, p.relative(file.path, from: source)),
    );
  }
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
  final directoryMoves = <DirectoryMove>[];
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
      directoryMoves,
      // The operation checks context.mounted before showing UI.
      // ignore: use_build_context_synchronously
      context,
      operation,
    )) {
      await _rollback(
        current,
        completedSteps,
        directoryMoves,
        // The operation checks context.mounted before showing UI.
        // ignore: use_build_context_synchronously
        context,
        operation,
      );
      await _rescanLocalState(files, current);
      return RenameTransactionResult(
        entities: current,
        succeeded: false,
        directoryMoves: List.unmodifiable(directoryMoves),
      );
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
      directoryMoves,
      // The operation checks context.mounted before showing UI.
      // ignore: use_build_context_synchronously
      context,
      operation,
    )) {
      await _rollback(
        current,
        completedSteps,
        directoryMoves,
        // The operation checks context.mounted before showing UI.
        // ignore: use_build_context_synchronously
        context,
        operation,
      );
      await _rescanLocalState(files, current);
      return RenameTransactionResult(
        entities: current,
        succeeded: false,
        directoryMoves: List.unmodifiable(directoryMoves),
      );
    }
  }

  return RenameTransactionResult(
    entities: current,
    succeeded: true,
    directoryMoves: List.unmodifiable(directoryMoves),
  );
}

Future<bool> _performRename(
  int index,
  FileEntity file,
  String previousName,
  List<FileEntity> current,
  List<_CompletedRename> completedSteps,
  List<DirectoryMove> directoryMoves,
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

  _updateCurrentEntity(current, index, file, renamed, directoryMoves);
  if (!identical(renamed, file)) {
    completedSteps.add(_CompletedRename(index, previousName));
  }
  return true;
}

/// Forward moves and rollback must both relocate descendants. Otherwise the
/// next child rollback would still address the directory's former location.
void _updateCurrentEntity(
  List<FileEntity> current,
  int index,
  FileEntity previous,
  FileEntity renamed,
  List<DirectoryMove> directoryMoves,
) {
  current[index] = renamed;
  // Selected descendants may also use a directory link as their path prefix.
  // Check its new location because the old link has already moved.
  if (previous.path != renamed.path &&
      !previous.path.startsWith('content://') &&
      renamed.fileOrDir() == 'Dir') {
    final move = DirectoryMove(previous.path, renamed.path);
    directoryMoves.add(move);
    _relocateDescendants(current, index, move);
  }
}

/// A directory move changes the paths of every selected descendant. Keep their
/// transaction entries in sync so later operations and rollback use the new
/// location as their source.
void _relocateDescendants(
  List<FileEntity> current,
  int renamedIndex,
  DirectoryMove move,
) {
  for (var index = 0; index < current.length; index++) {
    if (index != renamedIndex) current[index] = move.relocate(current[index]);
  }
}

Future<void> _rollback(
  List<FileEntity> current,
  List<_CompletedRename> completedSteps,
  List<DirectoryMove> directoryMoves,
  BuildContext? context,
  RenameOperation operation,
) async {
  for (final step in completedSteps.reversed) {
    final renamed = current[step.index];
    renamed.newName = step.previousName;
    try {
      final restored = await operation(renamed, context);
      if (restored != null) {
        _updateCurrentEntity(
          current,
          step.index,
          renamed,
          restored,
          directoryMoves,
        );
      }
    } catch (_) {
      // Continue rolling back the other entries, then rescan all local paths.
    }
  }
}

Set<int> _temporaryIndexes(List<FileEntity> files) {
  final localMoves = <int>[];
  final sourceKeys = <String>[];
  final targetKeys = <String>{};

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

  // Vacate each source that another move targets. For a -> b, b -> c this
  // means staging b; staging a would leave b occupied when a is committed.
  return {
    for (var moveIndex = 0; moveIndex < localMoves.length; moveIndex++)
      if (targetKeys.contains(sourceKeys[moveIndex])) localMoves[moveIndex],
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
    if (await FileSystemEntity.type(path, followLinks: false) ==
        FileSystemEntityType.notFound) {
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

    final originalType = await FileSystemEntity.type(
      originals[index].path,
      followLinks: false,
    );
    if (originalType != FileSystemEntityType.notFound) {
      current[index] = FileEntity(
        _entityForType(
          originals[index].path,
          originalType,
        ),
      );
      continue;
    }

    final renamedType = await FileSystemEntity.type(
      current[index].path,
      followLinks: false,
    );
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
    switch (type) {
      FileSystemEntityType.directory => Directory(path),
      FileSystemEntityType.link => Link(path),
      _ => File(path),
    };

Future<FileEntity?> _renameOperation(
  FileEntity file,
  BuildContext? context,
) =>
    rename(file, context: context);
