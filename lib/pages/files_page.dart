import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../entity/theme_extension.dart';
import '../l10n/l10n.dart';
import '../tools/platform_channel.dart';
import '../entity/constants.dart';
import '../tools/ex_file.dart';
import '../tools/file_sort.dart';
import '../tools/file_metadata.dart';
import '../entity/sharedpref.dart';
import '../tools/rename.dart';
import '../tools/rename_transaction.dart';
import '../widget/custom_dialog.dart';
import '../widget/custom_drop.dart';
import '../widget/file_thumbnail.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({
    super.key,
    this.showThumbnails = false,
    required this.getNewName,
    required this.clearRules,
    required this.resetRules,
    required this.dependsOnFileOrder,
    required this.requiresMetadata,
    this.onRenamingChanged,
  });

  final bool showThumbnails;

  final FutureOr<String> Function(String name, FileMetadata metadata)
      getNewName;
  final VoidCallback clearRules;
  final VoidCallback resetRules;

  /// Whether changing the list order changes generated names.  Increment is
  /// currently the only rule with this property.
  final bool Function() dependsOnFileOrder;

  /// Whether any active rule will read metadata while generating a name.
  final bool Function() requiresMetadata;

  /// Lets the parent lock rule/settings edits for the same operation.
  final ValueChanged<bool>? onRenamingChanged;

  @override
  State<FilesPage> createState() => FilesPageState();

  static void addFiles(Iterable<FileEntity> files) {
    _addUniqueFiles(files);
  }
}

final List<FileEntity> _files = [];

void _addUniqueFiles(Iterable<FileEntity> files) {
  final paths = _files.map((file) => file.path).toSet();
  _files.addAll(files.where((file) => paths.add(file.path)));
}

class FilesPageState extends State<FilesPage> {
  bool _dragging = false;
  bool _renaming = false;
  bool _deferredUpdate = false;
  bool _pickingIOSFiles = false;

  Future<void> _releaseUnusedIOSAccess() async {
    if (!Platform.isIOS || _pickingIOSFiles || _renaming) return;
    try {
      await PlatformFilePicker.retainScopedAccess(
        _files.map((file) => file.path),
      );
    } catch (error) {
      debugPrint('Unable to release unused folder access: $error');
    }
  }

  String _filter = '';
  FileSortField? _sortField;
  bool _sortAscending = true;
  int _sortGeneration = 0;
  final Map<FileEntity, Future<void>> _newNameFutures = {};
  int _newNameGeneration = 0;
  Future<void>? _newNamesReady;
  final Set<FileEntity> _collisionErrors = {};
  int _collisionCheckRevision = 0;
  final _BoundedTaskQueue _metadataQueue = _BoundedTaskQueue(maxConcurrent: 8);

  Future<void> addFileFromPicker() async {
    if (_renaming) return;
    late Iterable<FileEntity> entities;
    if (Platform.isAndroid) {
      if (!Shared.doNotRemindAgain) {
        await _remindDialog(context);
      }

      if (!mounted) {
        return;
      }

      List<String>? paths;
      if (Shared.fileOrDir == 'Directories') {
        paths = await PlatformFilePicker.dirAccess();
      } else {
        paths = await PlatformFilePicker.fileAccess(context, '');
      }

      if (paths == null || paths.isEmpty) return;
      entities = paths.map((path) {
        // A tree URI is still a `content://` URI, so it cannot be identified
        // from its path.  Preserve the picker mode in the entity type; the
        // list filter and the rename result both rely on it.
        final entity =
            Shared.fileOrDir == 'Directories' ? Directory(path) : File(path);
        return FileEntity(entity);
      });
    } else if (Platform.isIOS) {
      if (!Shared.doNotRemindAgain) {
        final iosOK = await _remindDialog(context);
        if (iosOK != null && !iosOK) {
          return;
        }
      }

      if (_pickingIOSFiles) return;
      _pickingIOSFiles = true;
      try {
        final dirs = await PlatformFilePicker.dirAccess();
        if (dirs == null || dirs.isEmpty || !mounted) return;
        final granted =
            await PlatformFilePicker.changeScopedAccess(dirs.first, true);
        if (!granted) {
          throw FileSystemException('Folder access was denied', dirs.first);
        }
        if (!mounted) return;
        final files = await PlatformFilePicker.fileAccess(context, dirs.first);
        if (files == null || !mounted || _renaming) return;
        setState(() {
          _addUniqueFiles(files.map((path) => path.toFileEntity()));
        });
      } catch (error) {
        if (mounted) {
          await showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(L10n.current.appError),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(L10n.current.ok),
                ),
              ],
            ),
          );
        }
      } finally {
        _pickingIOSFiles = false;
        await _releaseUnusedIOSAccess();
      }
      return;
    } else {
      final result = await FilePicker.pickFiles();
      if (result.isNotEmpty) {
        entities = result
            .where(
              (e1) =>
                  e1.path != null && _files.every((e2) => e1.path != e2.path),
            )
            .map((e) => e.toFileEntity());
      } else {
        return;
      }
    }
    if (!mounted || _renaming) return;
    setState(() {
      _addUniqueFiles(entities);
    });
  }

  Future<bool?> _remindDialog(BuildContext contextD) => showDialog<bool>(
        context: contextD,
        builder: (contextD) => CustomDialog(
          title: Text(
            Platform.isIOS
                ? L10n.current.iosRemindTitle
                : L10n.current.androidRemindTitle,
          ),
          content: Text(
            Platform.isIOS
                ? L10n.current.iosRemindContent
                : L10n.current.androidRemindContent,
          ),
          actions: [
            if (Platform.isIOS)
              TextButton(
                onPressed: () => Navigator.pop(contextD, false),
                child: Text(L10n.current.cancel),
              ),
            TextButton(
              onPressed: () => Navigator.pop(contextD, true),
              child: Text(L10n.current.ok),
            ),
            TextButton(
              onPressed: () {
                Shared.doNotRemindAgain = true;
                Navigator.pop(contextD, true);
              },
              child: Text(L10n.current.doNotRemindAgain),
            ),
          ],
        ),
      );

  void update() {
    if (_renaming) {
      // An already pending rule import/load may finish after the UI is locked.
      // Reject an uncommitted plan, or refresh once the active commit finishes.
      _deferredUpdate = true;
      return;
    }
    _invalidateNewNames();
    setState(() {});
  }

  void _invalidateNewNames() {
    _newNameGeneration++;
    _newNameFutures.clear();
    _newNamesReady = null;
    _collisionErrors.clear();
    _collisionCheckRevision++;
    for (final file in _files) {
      file.newName = null;
      file.error = null;
    }
  }

  Future<void> _newNameFuture(FileEntity file) {
    final generation = _newNameGeneration;
    if (!_files.contains(file)) {
      return getNewName(file, generation: generation);
    }

    if (_files.any((entry) => !_newNameFutures.containsKey(entry))) {
      // A target occupied by another source is safe only once that source's
      // final name is known. Generate the whole batch before checking it.
      _collisionCheckRevision++;
      final files = List<FileEntity>.of(_files);
      Future<void> preceding = Future.value();
      for (final entry in files) {
        final previous = preceding;
        preceding = _newNameFutures.putIfAbsent(entry, () {
          Future<void> generate() => getNewName(entry, generation: generation);
          if (widget.dependsOnFileOrder()) {
            return previous.then((_) => generate());
          }
          return widget.requiresMetadata()
              ? _metadataQueue.run(generate)
              : generate();
        });
      }

      late final Future<void> ready;
      ready = Future.wait(files.map((entry) => _newNameFutures[entry]!))
          .then((_) async {
        if (identical(_newNamesReady, ready)) {
          await _validateNewNameCollisions(generation);
        }
      });
      _newNamesReady = ready;
    }
    return _newNamesReady!;
  }

  Future<void> getNewName(
    FileEntity file, {
    int? generation,
  }) async {
    final requestedGeneration = generation ?? _newNameGeneration;
    if (_files.isNotEmpty && identical(file, _files.first)) {
      widget.resetRules.call();
    }

    if (requestedGeneration != _newNameGeneration) return;

    var filename = file.name;
    try {
      if (Platform.isAndroid && file.path.startsWith('content://')) {
        await file.initMetadata();
        if (requestedGeneration != _newNameGeneration) return;
        filename = file.metadata!.androidRealName;
      }
      final newName = replaceSpecialCharacters(
        await widget.getNewName(filename, file.metadataForRename),
      );

      if (requestedGeneration != _newNameGeneration) return;

      file.newName = newName;
      _collisionErrors.remove(file);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      if (requestedGeneration != _newNameGeneration) return;
      file.newName = filename;
      _collisionErrors.remove(file);
      file.error = e.toString();
      return;
    }

    file.error = null;
  }

  Future<void> _validateNewNameCollisions(int generation) async {
    if (!mounted || generation != _newNameGeneration || _renaming) return;
    await _buildRenamePlan(List<FileEntity>.of(_files), generation: generation);

    if (mounted && generation == _newNameGeneration) {
      setState(() {});
    }
  }

  List<FileEntity> _filteredList() {
    return _files
        .where(
          (element) =>
              element.name
                  .toString()
                  .toLowerCase()
                  .contains(_filter.toLowerCase()) &&
              Shared.fileOrDir.contains(element.fileOrDir()),
        )
        .toList();
  }

  Future<void> _sortFiles(FileSortField field) async {
    if (_renaming) return;
    final generation = ++_sortGeneration;
    late final bool ascending;
    setState(() {
      if (_sortField == field) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = true;
      }
      ascending = _sortAscending;
    });

    if (field == FileSortField.size || field == FileSortField.date) {
      await preloadFileSortMetadata(List<FileEntity>.of(_files));
    }

    if (!mounted || _renaming || generation != _sortGeneration) return;

    setState(() {
      _invalidateNewNamesForOrderChange();
      _files.sort((left, right) {
        final comparison = compareFiles(left, right, field);
        return ascending ? comparison : -comparison;
      });
    });
  }

  void _reorderFiles(int oldIndex, int newIndex) {
    if (_renaming) return;
    final visibleFiles = _filteredList();
    final movedFile = visibleFiles.removeAt(oldIndex);

    setState(() {
      _invalidateNewNamesForOrderChange();
      _files.remove(movedFile);
      if (newIndex == visibleFiles.length) {
        final lastVisibleFile = visibleFiles.lastOrNull;
        if (lastVisibleFile == null) {
          _files.add(movedFile);
        } else {
          _files.insert(_files.indexOf(lastVisibleFile) + 1, movedFile);
        }
      } else {
        _files.insert(_files.indexOf(visibleFiles[newIndex]), movedFile);
      }
    });
  }

  void _invalidateNewNamesForOrderChange() {
    if (widget.dependsOnFileOrder()) {
      _invalidateNewNames();
    }
  }

  TableCell _rowTextCell(FileEntity file, {bool isNew = false}) {
    if (!(Platform.isAndroid && file.path.startsWith('content://')) &&
        !file.existsSync()) {
      return TableCell(
        child: getRowText(L10n.current.fileNotExist, null),
      );
    }

    late final Widget content;

    if (isNew) {
      content = FutureBuilder(
        future: _newNameFuture(file),
        builder: (context, snap) {
          if ((snap.connectionState == ConnectionState.active ||
                  snap.connectionState == ConnectionState.done) &&
              (!snap.hasError)) {
            return getRowText(file.newName, file.error);
          }
          return const LinearProgressIndicator();
        },
      );
    } else if (Platform.isAndroid && file.path.startsWith('content://')) {
      content = FutureBuilder(
        future: file.initMetadata(),
        builder: (context, snap) {
          if ((snap.connectionState == ConnectionState.active ||
                  snap.connectionState == ConnectionState.done) &&
              (!snap.hasError)) {
            return getRowText(file.metadata!.androidRealName, file.error);
          }
          return const LinearProgressIndicator();
        },
      );
    } else {
      content = getRowText(file.name, null);
    }
    return TableCell(
      child: content,
    );
  }

  Widget getRowText(String text, String? error) {
    final textWidget = Text(
      text,
      semanticsLabel: text.toFilenameSemanticLabel(),
      style: TextStyle(
        fontSize: Platform.isAndroid ? 12 : 16,
        color: error != null ? Colors.red : null,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );

    if (error == null) {
      return textWidget;
    }

    return Tooltip(
      message: error,
      child: textWidget,
    );
  }

  TableRow _tableRow(FileEntity file, int index) {
    final fileListColors = Theme.of(context).extension<FileListColors>()!;
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? fileListColors.primaryColor
            : fileListColors.secondaryColor,
      ),
      children: [
        TableCell(
          child: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
        ),
        TableCell(
          child: Checkbox(
            value: file.selected,
            onChanged: (val) {
              if (_renaming) return;
              if (val != null) {
                setState(() {
                  file.selected = val;
                });
              }
            },
          ),
        ),
        if (widget.showThumbnails)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FileThumbnail(key: ValueKey(file.path), file: file),
            ),
          ),
        _rowTextCell(file),
        _rowTextCell(file, isNew: true),
        TableCell(
          child: IconButton(
            onPressed: () {
              if (_renaming) return;
              setState(() {
                _invalidateNewNames();
                _files.remove(file);
              });
              unawaited(_releaseUnusedIOSAccess());
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }

  List<TableRow> _headerRow() => [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          children: [
            const TableCell(child: SizedBox()),
            TableCell(
              child: Tooltip(
                message: _files.isNotEmpty &&
                        _files.every((element) => element.selected)
                    ? L10n.current.cancelAll
                    : L10n.current.selectAll,
                child: Checkbox(
                  value: _files.isNotEmpty &&
                      _files.every((element) => element.selected),
                  onChanged: (_) {
                    if (_renaming) return;
                    setState(() {
                      if (_files.every((element) => element.selected)) {
                        for (var element in _files) {
                          element.selected = false;
                        }
                      } else {
                        for (var element in _files) {
                          element.selected = true;
                        }
                      }
                    });
                  },
                ),
              ),
            ),
            if (widget.showThumbnails)
              TableCell(
                child: Tooltip(
                  message: L10n.current.showThumbnails,
                  child: const Icon(Icons.image_outlined),
                ),
              ),
            TableCell(
              child: Center(
                child: Text(L10n.current.currentName),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(L10n.current.newName),
              ),
            ),
            TableCell(
              child: Tooltip(
                message: L10n.current.removeAll,
                child: IconButton(
                  onPressed: () {
                    if (_renaming) return;
                    setState(() {
                      _invalidateNewNames();
                      _files.clear();
                    });
                    unawaited(_releaseUnusedIOSAccess());
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
      ];

  Widget _table(List<TableRow> children, {Key? key}) => Table(
        key: key,
        columnWidths: <int, TableColumnWidth>{
          0: const IntrinsicColumnWidth(),
          1: const IntrinsicColumnWidth(),
          if (widget.showThumbnails) 2: const FixedColumnWidth(56),
          widget.showThumbnails ? 3 : 2: const FlexColumnWidth(1.2),
          widget.showThumbnails ? 4 : 3: const FlexColumnWidth(1.5),
          widget.showThumbnails ? 5 : 4: const IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(width: 24, color: Colors.transparent),
        children: children,
      );

  @override
  Widget build(BuildContext context) => ExcludeFocus(
        excluding: _renaming,
        child: AbsorbPointer(
          absorbing: _renaming,
          child: _buildContent(context),
        ),
      );

  Widget _buildContent(BuildContext context) {
    final filteredFiles = _filteredList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              CustomDrop<String>(
                value: Shared.fileOrDir,
                onChanged: (String? newValue) {
                  if (_renaming) return;
                  setState(() {
                    Shared.fileOrDir = newValue!;
                  });
                },
                items: const <String>['Files', 'Directories', 'Files & Dirs'],
                tToStr: (obj) => {
                  'Files': L10n.current.files,
                  'Directories': L10n.current.directories,
                  'Files & Dirs': L10n.current.filesDirs,
                }[obj]!,
                semanticsAppendix: L10n.current.semanticsFilesDropdownButton,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: L10n.current.filter,
                  ),
                  onChanged: (val) {
                    if (_renaming) return;
                    setState(() {
                      _filter = val;
                    });
                  },
                ),
              ),
              box,
              PopupMenuButton<FileSortField>(
                icon: const Icon(Icons.sort_by_alpha),
                tooltip: L10n.current.fileManagerSortButton,
                onSelected: _sortFiles,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: FileSortField.name,
                    child: Text(L10n.current.fileSortName),
                  ),
                  PopupMenuItem(
                    value: FileSortField.size,
                    child: Text(L10n.current.fileSortSize),
                  ),
                  PopupMenuItem(
                    value: FileSortField.date,
                    child: Text(L10n.current.fileSortDate),
                  ),
                  PopupMenuItem(
                    value: FileSortField.type,
                    child: Text(L10n.current.fileSortType),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _sortFiles(_sortField ?? FileSortField.name),
                icon: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                ),
                tooltip: L10n.current.fileManagerSortButton,
              ),
              IconButton(
                onPressed: addFileFromPicker,
                icon: const Icon(Icons.add),
                tooltip: L10n.current.addFile,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _table(_headerRow()),
        Expanded(
          child: DropTarget(
            enable: !_renaming && !(Platform.isIOS || Platform.isAndroid),
            onDragDone: (detail) async {
              if (_renaming) return;
              for (var xFile in detail.files) {
                final FileEntity file = xFile.toFileEntity();

                if (_files.every((exist) => file.path != exist.path)) {
                  setState(() {
                    _files.add(file);
                  });
                }
              }

              setState(() {
                _dragging = false;
              });
            },
            onDragEntered: (detail) {
              if (_renaming) return;
              setState(() {
                _dragging = true;
              });
            },
            onDragExited: (detail) {
              setState(() {
                _dragging = false;
              });
            },
            onDragUpdated: (detail) {},
            child: Container(
              color:
                  Theme.of(context).extension<FileListColors>()!.primaryColor,
              child: Stack(
                children: [
                  if (_files.isNotEmpty)
                    ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      onReorderItem: _reorderFiles,
                      itemCount: filteredFiles.length,
                      itemBuilder: (context, index) {
                        final file = filteredFiles[index];
                        return _table(
                          [
                            _tableRow(file, index),
                          ],
                          key: ValueKey(file),
                        );
                      },
                    )
                  else if (!_dragging)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Text(
                          Platform.isIOS
                              ? L10n.current.addFiles
                              : (Platform.isAndroid
                                  ? L10n.current.addFilesAndroid
                                  : L10n.current.dragToAdd),
                        ),
                      ),
                    ),
                  if (_dragging)
                    Container(
                      color: Colors.blue.withValues(alpha: 0.2),
                      child: Center(
                        child: Text(L10n.current.dropToAdd),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> renameFiles({
    bool remove = true,
    bool onlySelected = false,
  }) async {
    if (_renaming || !mounted) return;
    // Discard a metadata sort that started before this operation, even if its
    // result arrives after the rename has finished.
    _sortGeneration++;
    _setRenaming(true);

    try {
      final requestedFiles = _files
          .where((file) => file.selected || !onlySelected)
          .toList(growable: false);
      for (final file in requestedFiles) {
        await _newNameFuture(file);
      }
      if (!mounted || _deferredUpdate) return;
      final filesToRename = await _buildRenamePlan(requestedFiles);
      var noError = filesToRename.length == requestedFiles.length;

      if (mounted) {
        setState(() {});
      }
      if (!noError) return;

      final mediaUris = <String>[];
      if (Platform.isAndroid) {
        for (final file in filesToRename) {
          if (file.path.startsWith('content://')) {
            await file.initMetadata();
            if (file.metadata!.androidRealName != file.newName) {
              mediaUris.add(file.path);
            }
          }
        }
      }
      final mediaPermission = Platform.isAndroid
          ? await PlatformFilePicker.requestMediaWritePermission(mediaUris)
          : const MediaWritePermission.empty();
      if (!mounted || _deferredUpdate) return;

      final deniedFiles = filesToRename.where(
        (file) =>
            mediaPermission.candidates.contains(file.path) &&
            !mediaPermission.approved.contains(file.path),
      );
      if (deniedFiles.isNotEmpty) {
        noError = false;
        setState(() {
          for (final file in deniedFiles) {
            file.error = L10n.current.renameFailed;
          }
        });
        return;
      }

      final result = await commitRenameTransaction(
        filesToRename,
        context: context,
      );
      noError = noError && result.succeeded;
      if (!mounted) return;

      setState(() {
        final participants = filesToRename.toSet();
        for (var index = 0; index < _files.length; index++) {
          if (!participants.contains(_files[index])) {
            _files[index] = result.relocateDescendant(_files[index]);
          }
        }
        for (var index = 0; index < filesToRename.length; index++) {
          final original = filesToRename[index];
          final listIndex = _files.indexOf(original);
          if (listIndex < 0) continue;
          if (result.succeeded && remove) {
            _files.removeAt(listIndex);
          } else {
            _files[listIndex] = result.entities[index];
          }
        }
        _invalidateNewNames();
        if (!result.succeeded) {
          for (final file in result.entities) {
            file.error = L10n.current.renameFailed;
          }
        }
      });

      if (noError && remove) {
        widget.clearRules.call();
      }
    } finally {
      if (_deferredUpdate) {
        _deferredUpdate = false;
        _invalidateNewNames();
      }
      _setRenaming(false);
      await _releaseUnusedIOSAccess();
    }
  }

  void _setRenaming(bool value) {
    _renaming = value;
    _dragging = false;
    if (mounted) setState(() {});
    widget.onRenamingChanged?.call(value);
  }

  Future<List<FileEntity>> _buildRenamePlan(
    List<FileEntity> requestedFiles, {
    int? generation,
  }) async {
    final requestedGeneration = generation ?? _newNameGeneration;
    final revision = ++_collisionCheckRevision;
    final localFiles = <FileEntity>[];
    final safFiles = <FileEntity>[];
    for (final file in requestedFiles) {
      file.newName = replaceSpecialCharacters(file.newName);
      // Recheck collision errors for this batch: the selected subset or disk
      // contents may have changed since preview. Preserve generation errors.
      if (file.error != null && !_collisionErrors.contains(file)) continue;
      if (Platform.isAndroid && file.path.startsWith('content://')) {
        safFiles.add(file);
      } else {
        localFiles.add(file);
      }
    }

    // Snapshot paths before asynchronous filesystem checks. Only publish the
    // result if both the names and this validation request are still current.
    final sources = {for (final file in localFiles) file: _sourcePathKey(file)};
    final targets = {for (final file in localFiles) file: _targetPathKey(file)};
    final paths = {for (final file in localFiles) file: file.newPath};
    final collisions = <FileEntity>{};
    final targetGroups = <String, List<FileEntity>>{};
    for (final file in localFiles) {
      targetGroups.putIfAbsent(targets[file]!, () => []).add(file);
    }
    for (final group in targetGroups.values) {
      if (group.length > 1) {
        collisions.addAll(group);
      }
    }

    // Repeat this check after every newly blocked move. A destination can only
    // be considered free when its selected source will actually move away.
    var foundBlockedMove = true;
    while (foundBlockedMove) {
      foundBlockedMove = false;
      final plannedMoves = localFiles
          .where(
            (file) =>
                !collisions.contains(file) && sources[file] != targets[file],
          )
          .toList();
      final movingSources = plannedMoves.map((file) => sources[file]).toSet();
      for (final file in plannedMoves) {
        final target = targets[file];
        if (!movingSources.contains(target) &&
            await FileSystemEntity.type(
                  paths[file]!,
                  followLinks: false,
                ) !=
                FileSystemEntityType.notFound) {
          collisions.add(file);
          foundBlockedMove = true;
        }
      }
    }

    if (requestedGeneration != _newNameGeneration ||
        revision != _collisionCheckRevision) {
      return [];
    }
    for (final file in requestedFiles) {
      if (_collisionErrors.remove(file)) file.error = null;
    }
    for (final file in collisions) {
      file.error = L10n.current.fileAlreadyExists;
    }
    _collisionErrors.addAll(collisions);
    return [
      ...localFiles.where((file) => !collisions.contains(file)),
      ...safFiles,
    ];
  }

  String _sourcePathKey(FileEntity file) => _normalisedPath(file.path);

  String _targetPathKey(FileEntity file) => _normalisedPath(file.newPath);

  String _normalisedPath(String path) {
    final absolutePath = File(path).absolute.path;
    return Platform.isWindows || Platform.isMacOS || Platform.isIOS
        ? absolutePath.toLowerCase()
        : absolutePath;
  }
}

/// Limits expensive per-file metadata work while allowing independent rules to
/// keep the UI responsive for large selections.
class _BoundedTaskQueue {
  _BoundedTaskQueue({required this.maxConcurrent});

  final int maxConcurrent;
  final List<void Function()> _pending = [];
  int _active = 0;

  Future<T> run<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _pending.add(() async {
      try {
        completer.complete(await task());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      } finally {
        _active--;
        _startNext();
      }
    });
    _startNext();
    return completer.future;
  }

  void _startNext() {
    while (_active < maxConcurrent && _pending.isNotEmpty) {
      _active++;
      _pending.removeAt(0)();
    }
  }
}
