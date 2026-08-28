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
import '../tools/file_metadata.dart';
import '../entity/sharedpref.dart';
import '../tools/rename.dart';
import '../widget/custom_dialog.dart';
import '../widget/custom_drop.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({
    super.key,
    required this.getNewName,
    required this.clearRules,
    required this.resetRules,
  });

  final FutureOr<String> Function(String name, FileMetadata metadata)
      getNewName;
  final VoidCallback clearRules;
  final VoidCallback resetRules;

  @override
  State<FilesPage> createState() => FilesPageState();

  static void addFiles(Iterable<FileEntity> files) {
    _files.addAll(files);
  }
}

final List<FileEntity> _files = [];

class FilesPageState extends State<FilesPage> {
  bool _dragging = false;
  bool _renaming = false;
  String _filter = '';

  Future<void> addFileFromPicker() async {
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

      final dirs = await PlatformFilePicker.dirAccess();
      if (dirs == null || dirs.isEmpty) {
        return;
      }

      if (!_files.any((e) => e.parent.path == dirs.first.toString())) {
        await PlatformFilePicker.changeScopedAccess(
            dirs.first.toString(), true);
      }

      final files =
          await PlatformFilePicker.fileAccess(context, dirs.first.toString());
      if (files == null) {
        return;
      }

      entities = files
          .skipWhile((e) => e == null)
          .map((e) => e.toString())
          .map((e) => e.toFileEntity());
    } else {
      FilePickerResult? result = await FilePicker.pickFiles();
      if (result != null) {
        entities = result.files
            .where((e1) =>
                e1.path != null && _files.every((e2) => e1.path != e2.path))
            .map((e) => e.toFileEntity());
      } else {
        return;
      }
    }
    setState(() {
      _files.addAll(entities
          .skipWhile((eNew) => _files.any((eOld) => eNew.path == eOld.path)));
    });
  }

  Future<bool?> _remindDialog(BuildContext contextD) => showDialog<bool>(
        context: contextD,
        builder: (contextD) => CustomDialog(
          title: Text(Platform.isIOS
              ? L10n.current.iosRemindTitle
              : L10n.current.androidRemindTitle),
          content: Text(Platform.isIOS
              ? L10n.current.iosRemindContent
              : L10n.current.androidRemindContent),
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

  void update() => setState(() {});

  Future<void> getNewName(FileEntity file) async {
    if (file == _files.first) {
      widget.resetRules.call();
    }

    await file.initMetadata();

    late final String filename;

    if (Platform.isAndroid && file.path.startsWith('content://')) {
      filename = file.metadata!.androidRealName;
    } else {
      filename = file.name;
    }

    try {
      file.newName = replaceSpecialCharacters(
        await widget.getNewName(filename, file.metadata!),
      );
      final isAndroidUri =
          Platform.isAndroid && file.path.startsWith('content://');
      if (file.newName != filename &&
          ((!isAndroidUri && await File(file.newPath).exists()) ||
              file.isNewNameDuplicate(_files))) {
        file.error = L10n.current.fileAlreadyExists;
        return;
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      file.newName = filename;
      file.error = e.toString();
      return;
    }

    file.error = null;
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
        future: getNewName(file),
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
    file.initMetadata();
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

  List<TableRow> _tableRows() {
    final filteredList = _filteredList();
    final fileListColors = Theme.of(context).extension<FileListColors>()!;
    return List.generate(
      filteredList.length,
      (index) => TableRow(
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? fileListColors.primaryColor
              : fileListColors.secondaryColor,
        ),
        children: [
          TableCell(
            child: Checkbox(
              value: filteredList[index].selected,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    filteredList[index].selected = val;
                  });
                }
              },
            ),
          ),
          _rowTextCell(filteredList[index]),
          _rowTextCell(filteredList[index], isNew: true),
          TableCell(
            child: IconButton(
              onPressed: () {
                setState(() {
                  _files.removeWhere(
                    (element) => element.path == filteredList[index].path,
                  );
                });
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }

  List<TableRow> _headerRow() => [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          children: [
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
                    setState(() {
                      _files.clear();
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
      ];

  Widget _table(List<TableRow> children) => Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.5),
          3: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(width: 24, color: Colors.transparent),
        children: children,
      );

  @override
  Widget build(BuildContext context) {
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
                    setState(() {
                      _filter = val;
                    });
                  },
                ),
              ),
              box,
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
            enable: !(Platform.isIOS || Platform.isAndroid),
            onDragDone: (detail) async {
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
                    SingleChildScrollView(
                      child: _table(_tableRows()),
                    )
                  else if (!_dragging)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Text(Platform.isIOS
                            ? L10n.current.addFiles
                            : (Platform.isAndroid
                                ? L10n.current.addFilesAndroid
                                : L10n.current.dragToAdd)),
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
    if (_renaming) return;
    _renaming = true;

    try {
      final requestedFiles = _files
          .where((file) => file.selected || !onlySelected)
          .toList(growable: false);
      final filesToRename = await _buildRenamePlan(requestedFiles);
      var noError = filesToRename.length == requestedFiles.length;

      if (mounted) {
        setState(() {});
      }

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
      if (!mounted) return;

      for (final file in filesToRename) {
        final index = _files.indexOf(file);
        final deniedMediaWrite =
            mediaPermission.candidates.contains(file.path) &&
                !mediaPermission.approved.contains(file.path);

        if (deniedMediaWrite) {
          noError = false;
          setState(() {
            file.error = L10n.current.renameFailed;
          });
          continue;
        }

        final value = await rename(
          file,
          context: context,
        );
        if (value == null) {
          noError = false;
          if (mounted) {
            setState(() {
              file.error = L10n.current.renameFailed;
            });
          }
        } else if (remove) {
          if (mounted) {
            setState(() {
              _files.remove(file);
            });
          }

          if (Platform.isIOS &&
              !_files.any((e) => e.parent.path == file.parent.path)) {
            PlatformFilePicker.changeScopedAccess(file.parent.path, false);
          }
        } else if (mounted && index >= 0) {
          setState(() {
            _files[index] = value;
          });
        }
      }

      if (noError && remove) {
        widget.clearRules.call();
      }
    } finally {
      _renaming = false;
    }
  }

  Future<List<FileEntity>> _buildRenamePlan(
    List<FileEntity> requestedFiles,
  ) async {
    final localFiles = <FileEntity>[];
    final safFiles = <FileEntity>[];
    for (final file in requestedFiles) {
      file.newName = replaceSpecialCharacters(file.newName);
      if (file.error != null) continue;
      if (Platform.isAndroid && file.path.startsWith('content://')) {
        safFiles.add(file);
      } else {
        localFiles.add(file);
      }
    }

    final targetGroups = <String, List<FileEntity>>{};
    for (final file in localFiles) {
      targetGroups.putIfAbsent(_targetPathKey(file), () => []).add(file);
    }
    for (final group in targetGroups.values) {
      if (group.length > 1) {
        for (final file in group) {
          file.error = L10n.current.fileAlreadyExists;
        }
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
                file.error == null &&
                _sourcePathKey(file) != _targetPathKey(file),
          )
          .toList();
      final movingSources = plannedMoves.map(_sourcePathKey).toSet();
      for (final file in plannedMoves) {
        final target = _targetPathKey(file);
        if (!movingSources.contains(target) &&
            await FileSystemEntity.type(
                  file.newPath,
                ) !=
                FileSystemEntityType.notFound) {
          file.error = L10n.current.fileAlreadyExists;
          foundBlockedMove = true;
        }
      }
    }

    final orderedLocalMoves = <FileEntity>[];
    final pendingMoves = localFiles
        .where(
          (file) =>
              file.error == null &&
              _sourcePathKey(file) != _targetPathKey(file),
        )
        .toList();
    while (pendingMoves.isNotEmpty) {
      final ready = pendingMoves.where((file) {
        final target = _targetPathKey(file);
        return pendingMoves.every(
          (other) => identical(file, other) || _sourcePathKey(other) != target,
        );
      }).toList();
      if (ready.isEmpty) {
        for (final file in pendingMoves) {
          file.error = L10n.current.renameFailed;
        }
        break;
      }
      orderedLocalMoves.addAll(ready);
      pendingMoves.removeWhere(ready.contains);
    }

    final localNoOps = localFiles.where(
      (file) =>
          file.error == null && _sourcePathKey(file) == _targetPathKey(file),
    );
    return [...orderedLocalMoves, ...localNoOps, ...safFiles];
  }

  String _sourcePathKey(FileEntity file) => _normalisedPath(file.path);

  String _targetPathKey(FileEntity file) => _normalisedPath(file.newPath);

  String _normalisedPath(String path) {
    final absolutePath = File(path).absolute.path;
    return Platform.isWindows ? absolutePath.toLowerCase() : absolutePath;
  }
}
