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

  final FutureOr<String> Function(String name, FileMetadata metadata) getNewName;
  final VoidCallback clearRules;
  final VoidCallback resetRules;

  @override
  State<FilesPage> createState() => FilesPageState();

  static void addFiles(Iterable<FileSystemEntity> files) {
    _files.addAll(files);
  }
}

final List<FileSystemEntity> _files = [];

class FilesPageState extends State<FilesPage> {
  bool _dragging = false;
  String _filter = '';

  Future<void> addFileFromPicker() async {
    late Iterable<FileSystemEntity> entities;
    if (Platform.isAndroid) {
      if (!Shared.doNotRemindAgain) {
        await _remindDialog(context);
      }

      if (!mounted) {
        return;
      }

      List<Object?>? paths;
      if (Shared.fileOrDir == 'Directories') {
        paths = await PlatformFilePicker.dirAccess();
      } else {
        paths = await PlatformFilePicker.fileAccess('');
      }

      if (paths == null || paths.isEmpty) return;
      entities = paths.map((e) => e.toString()).map((e) => File(e));
    } else if (Platform.isIOS) {
      if (!Shared.doNotRemindAgain) {
        final iosOK = await _remindDialog(context);
        if (iosOK != null && !iosOK) {
          return;
        }
      }

      final dirs = await PlatformFilePicker.dirAccess();
      if (dirs == null || dirs.first == null) {
        return;
      }

      if (!_files.any((e) => e.parent.path == dirs.first.toString())) {
        await PlatformFilePicker.changeScopedAccess(dirs.first.toString(), true);
      }

      final files = await PlatformFilePicker.fileAccess(dirs.first.toString());
      if (files == null) {
        return;
      }

      entities = files.skipWhile((e) => e == null).map((e) => e.toString()).map((e) => e.toFileSystemEntity());
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        entities = result.files
            .where((e1) => e1.path != null && _files.every((e2) => e1.path != e2.path))
            .map((e) => e.toFileSystemEntity());
      } else {
        return;
      }
    }
    setState(() {
      _files.addAll(entities.skipWhile((eNew) => _files.any((eOld) => eNew.path == eOld.path)));
    });
  }

  Future<bool?> _remindDialog(BuildContext contextD) => showDialog<bool>(
    context: contextD,
    builder: (contextD) => CustomDialog(
      title: Text(Platform.isIOS ? L10n.current.iosRemindTitle : L10n.current.androidRemindTitle),
      content: Text(Platform.isIOS ? L10n.current.iosRemindContent : L10n.current.androidRemindContent),
      actions: [
        if (Platform.isIOS) TextButton(
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

  Future<void> getNewName(FileSystemEntity file) async {
    if (file == _files.first) {
      widget.resetRules.call();
    }

    late final String filename;

    if (Platform.isAndroid && file.path.startsWith('content://')) {
      filename = file.metadata!.androidRealName;
    } else {
      filename = file.name;
    }

    try {
      file.newName = await widget.getNewName(filename, file.metadata!);
      if (file.newName != filename && ((await File(file.newPath).exists()) || file.newNameDuplicate)) {
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

  List<FileSystemEntity> _filteredList() {
    return _files
        .where(
          (element) =>
              element.name.toString().toLowerCase().contains(_filter.toLowerCase()) &&
              Shared.fileOrDir.contains(element.fileOrDir()),
        )
        .toList();
  }

  TableCell _rowTextCell(FileSystemEntity file, {bool isNew = false}) {
    if (!(Platform.isAndroid && file.path.startsWith('content://')) && !file.existsSync()) {
      return TableCell(
        child: getRowText(L10n.current.fileNotExist, null),
      );
    }

    file.initMetadata();

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
      content = getRowText(file.metadata!.androidRealName, null);
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

  List<TableRow> _tableRows() {
    final filteredList = _filteredList();
    final fileListColors = Theme.of(context).extension<FileListColors>()!;
    return List.generate(
      filteredList.length,
      (index) => TableRow(
        decoration: BoxDecoration(
          color: index % 2 == 0 ? fileListColors.primaryColor : fileListColors.secondaryColor,
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
              icon: const Icon(Icons.clear),
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
                message: _files.isNotEmpty && _files.every((element) => element.selected)
                    ? L10n.current.cancelAll
                    : L10n.current.selectAll,
                child: Checkbox(
                  value: _files.isNotEmpty && _files.every((element) => element.selected),
                  onChanged: (_) {
                    setState(() {
                      if (_files.every((element) => element.selected)) {
                        ExFile.clearSelections();
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
                  icon: const Icon(Icons.clear),
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
              TextButton(
                onPressed: addFileFromPicker,
                child: Text(L10n.current.addFile),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _table(_headerRow()),
        Expanded(
          child: DropTarget(
            enable: !Platform.isIOS,
            onDragDone: (detail) async {
              for (var xFile in detail.files) {
                final FileSystemEntity file = xFile.toFileSystemEntity();

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
              color: Theme.of(context).extension<FileListColors>()!.primaryColor,
              child: Stack(
                children: [
                  if (_files.isNotEmpty)
                    SingleChildScrollView(
                      child: _table(_tableRows()),
                    )
                  else if (!_dragging)
                    Center(
                      child: Text(Platform.isIOS ? L10n.current.addFiles : L10n.current.dragToAdd),
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
    final List<Future> futures = [];
    bool noError = true;
    _files.asMap().forEach((index, file) {
      // if file is selected or onlySelected = false (all files should be renamed)
      if (file.selected || !onlySelected) {
        futures.add(
          rename(
            file,
            context: context,
          ).then((value) {
            if (value == null) {
              noError = false;
              setState(() {
                file.error = L10n.current.renameFailed;
              });
            } else if (remove) {
              setState(() {
                _files.remove(file);
              });

              if (Platform.isIOS && !_files.any((e) => e.parent.path == file.parent.path)) {
                PlatformFilePicker.changeScopedAccess(file.parent.path, false);
              }
            } else {
              setState(() {
                _files[index] = value;
              });
            }
          }),
        );
      }
    });

    await Future.wait(futures);

    if (noError && remove) {
      widget.clearRules.call();
    }
  }
}
