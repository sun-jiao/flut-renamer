import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../widget/custom_drop.dart';
import '../entity/select_x.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key, required this.getNewName});

  final String Function(String name) getNewName;

  @override
  State<FilesPage> createState() => FilesPageState();
}

class FilesPageState extends State<FilesPage> {
  String _type = 'Files';

  final List<XFile> _list = [];

  bool _dragging = false;

  String _filter = '';

  Future<void> addFileFromPicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        final resultFiles = result.files
            .where((e1) =>
                e1.path != null && _list.every((e2) => e1.path != e2.path))
            .toList();
        _list.addAll(List.generate(
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

  void update() {
    setState(() {

    });
  }

  String getNewName(String name) {
    return widget.getNewName(name);
  }

  List<XFile> _filteredList() {
    return _list
        .where((element) =>
            element.name
                .toString()
                .toLowerCase()
                .contains(_filter.toLowerCase()) &&
            _type.contains(element.fileOrDir()))
        .toList();
  }

  TableCell _rowTextCell(XFile xFile, {bool isNew = false}) =>
      TableCell(
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
                        _list.removeWhere((element) =>
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
                message: _list.isNotEmpty &&
                        _list.every((element) => element.selected)
                    ? 'Cancel All'
                    : 'Select All',
                child: Checkbox(
                    value: _list.isNotEmpty &&
                        _list.every((element) => element.selected),
                    onChanged: (_) {
                      setState(() {
                        if (_list.every((element) => element.selected)) {
                          SelectX.clearSelections();
                        } else {
                          for (var element in _list) {
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
                      _list.clear();
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
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
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
            ],
          ),
          const SizedBox(height: 16),
          _table(_headerRow()),
          Expanded(
            child: DropTarget(
              onDragDone: (detail) {
                setState(() {
                  _list.addAll(detail.files
                      .where((e1) => _list.every((e2) => e1.path != e2.path)));
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
                    if (_list.isNotEmpty)
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
              ElevatedButton(
                onPressed: addFileFromPicker,
                child: const Text('Add File'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Rename'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Rename & Clear All'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
