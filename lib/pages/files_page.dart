import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:renamer/tools/rename.dart';

import '../widget/custom_drop.dart';
import '../entity/select_x.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({
    super.key,
    required this.getNewName,
    required this.clearRules,
  });

  final String Function(String name) getNewName;
  final VoidCallback clearRules;

  @override
  State<FilesPage> createState() => FilesPageState();
}

class FilesPageState extends State<FilesPage> {
  String _type = 'Files';
  late final List<XFile> _files;
  bool _dragging = false;
  bool _remove = true;
  bool _onlySelected = false;
  String _filter = '';

  @override
  initState() {
    _files = [];
    super.initState();
  }

  Future<void> addFileFromPicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        final resultFiles = result.files
            .where((e1) =>
                e1.path != null && _files.every((e2) => e1.path != e2.path))
            .toList();
        _files.addAll(List.generate(
            resultFiles.length,
            (index) => XFile(
                  resultFiles[index].path!,
                  name: resultFiles[index].name,
                  length: resultFiles[index].size,
                  bytes: resultFiles[index].bytes,
                )));
      });
    }
  }

  void update() => setState(() {});

  String getNewName(String name) => widget.getNewName(name);

  List<XFile> _filteredList() {
    return _files
        .where((element) =>
            element.name
                .toString()
                .toLowerCase()
                .contains(_filter.toLowerCase()) &&
            _type.contains(element.fileOrDir()))
        .toList();
  }

  TableCell _rowTextCell(XFile xFile, {bool isNew = false}) => TableCell(
        child: Text(
          isNew ? getNewName(xFile.name) : xFile.name,
          style: TextStyle(
            fontSize: 16,
            color: xFile.error ? Colors.red : Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  List<TableRow> _tableRows() {
    final filteredList = _filteredList();
    return List.generate(
        filteredList.length,
        (index) => TableRow(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white : Colors.blueGrey.shade50,
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
                      }),
                ),
                _rowTextCell(filteredList[index]),
                _rowTextCell(filteredList[index], isNew: true),
                TableCell(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _files.removeWhere((element) =>
                            element.path == filteredList[index].path);
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ],
            ));
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
                    ? 'Cancel All'
                    : 'Select All',
                child: Checkbox(
                    value: _files.isNotEmpty &&
                        _files.every((element) => element.selected),
                    onChanged: (_) {
                      setState(() {
                        if (_files.every((element) => element.selected)) {
                          SelectX.clearSelections();
                        } else {
                          for (var element in _files) {
                            element.selected = true;
                          }
                        }
                      });
                    }),
              ),
            ),
            const TableCell(
              child: Center(
                child: Text('Current Name'),
              ),
            ),
            const TableCell(
              child: Center(
                child: Text('New Name'),
              ),
            ),
            TableCell(
              child: Tooltip(
                message: 'Clear All',
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
          1: FlexColumnWidth(1.0),
          2: FlexColumnWidth(1.5),
          3: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(width: 24, color: Colors.transparent),
        children: children,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CustomDrop<String>(
                value: _type,
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue!;
                  });
                },
                items: const <String>['Files', 'Directories', 'Files & Dirs'],
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Filter',
                  ),
                  onChanged: (val) {
                    setState(() {
                      _filter = val;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: addFileFromPicker,
                child: const Text('Add File'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _table(_headerRow()),
          Expanded(
            child: DropTarget(
              onDragDone: (detail) {
                setState(() {
                  _files.addAll(detail.files
                      .where((e1) => _files.every((e2) => e1.path != e2.path)));
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
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    if (_files.isNotEmpty)
                      SingleChildScrollView(
                        child: _table(_tableRows()),
                      )
                    else if (!_dragging)
                      const Center(
                        child: Text('Drag and drop to add files.'),
                      ),
                    if (_dragging)
                      Container(
                        color: Colors.blue.withOpacity(0.2),
                        child: const Center(
                          child: Text('Drop to add files.'),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(width: 16),
              Checkbox(
                value: _onlySelected,
                onChanged: (value) {
                  setState(() {
                    _onlySelected = value ?? _onlySelected;
                  });
                },
              ),
              const Text('only selected'),
              const SizedBox(width: 16),
              Checkbox(
                value: _remove,
                onChanged: (value) {
                  setState(() {
                    _remove = value ?? _remove;
                  });
                },
              ),
              const Text('remove renamed'),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  renameFiles(remove: _remove, onlySelected: _onlySelected);
                },
                child: const Text('Rename All'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> renameFiles(
      {bool remove = true, bool onlySelected = false}) async {
    final List<Future> futures = [];
    _files.asMap().forEach((index, file) {
      // if file is selected or onlySelected = false (all files should be renamed)
      if (file.selected || !onlySelected) {
        futures.add(rename(file, (name) => getNewName(name), context: context)
            .then((value) {
          if (value == null) {
            setState(() {
              file.error = true;
            });
          } else if (remove) {
            setState(() {
              _files.remove(file);
            });
          } else {
            setState(() {
              _files[index] = value;
            });
          }
        }));
      }
    });

    await Future.wait(futures);
  }
}
