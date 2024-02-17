/// Modified based on the example of library `file_manager`:
/// https://github.com/DevsOnFlutter/file_manager/blob/main/example/lib/main.dart
/// Originally distributed under BSD-3-Clause license

import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:renamer/tools/ex_file.dart';

/// Only flutter supported:
/// https://api.flutter.dev/flutter/widgets/Image-class.html
const _imageExts = [
  'JPG',
  'JPEG',
  'JPE',
  'JIF',
  'JFIF',
  'JFI',
  'PNG',
  'GIF',
  'WEBP',
  'BMP',
  'WBMP',
];

class AndroidFilePicker extends StatefulWidget {
  const AndroidFilePicker({super.key});

  @override
  State<AndroidFilePicker> createState() => _AndroidFilePickerState();
}

GlobalKey<State<StatefulBuilder>> _stfKey = GlobalKey<State<StatefulBuilder>>();

class _AndroidFilePickerState extends State<AndroidFilePicker> {
  final FileManagerController controller = FileManagerController();

  List<FileSystemEntity> _selected = [];
  List<FileSystemEntity> entities = [];

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
        appBar: appBar(context),
        body: FileManager(
          controller: controller,
          builder: (context, snapshot) {
            entities = snapshot;
            return StatefulBuilder(
              key: _stfKey,
              builder: (contextS, setStateS) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  FileSystemEntity entity = entities[index];
                  return Card(
                    child: ListTile(
                      leading: getIcon(entity),
                      trailing: _selected.contains(entity)
                          ? const Icon(Icons.task_alt_outlined)
                          : null,
                      title: Text(
                        FileManager.basename(
                          entity,
                          showFileExtension: true,
                        ),
                      ),
                      subtitle: subtitle(entity),
                      onTap: () async {
                        if (FileManager.isDirectory(entity)) {
                          // open the folder
                          controller.openDirectory(entity);
                        } else {
                          // select or unselect a file
                          setStateS(() {
                            if (_selected.contains(entity)) {
                              _selected.remove(entity);
                            } else {
                              _selected.add(entity);
                            }
                          });
                        }
                      },
                      onLongPress: () async {
                        // select or unselect a file or a dir
                        setStateS(() {
                          if (_selected.contains(entity)) {
                            _selected.remove(entity);
                          } else {
                            _selected.add(entity);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getIcon(FileSystemEntity entity) {
    if (FileManager.isFile(entity)) {
      final ext = entity.name.split('.').last;
      if (_imageExts.contains(ext.toUpperCase())) {
        return Image.file(
          entity as File,
          width: 24,
          height: 24,
        );
      } else {
        return const Icon(Icons.feed);
      }
    }
    return const Icon(Icons.folder);
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => sort(context),
          icon: const Icon(Icons.sort_rounded),
        ),
        IconButton(
          onPressed: () => selectStorage(context),
          icon: const Icon(Icons.sd_storage_rounded),
        ),
        IconButton(
          onPressed: () => selectAll(),
          icon: const Icon(Icons.select_all_rounded),
        ),
        IconButton(
          onPressed: () => saveSelected(context),
          icon: const Icon(Icons.save),
        ),
      ],
      title: ValueListenableBuilder<String>(
        valueListenable: controller.titleNotifier,
        builder: (context, title, _) => Text(title),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          await controller.goToParentDirectory();
        },
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              FileManager.formatBytes(size),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return const Text("");
        }
      },
    );
  }

  void selectAll() {
    _stfKey.currentState?.setState(() {
      _selected.addAll(entities.where((e) => !_selected.contains(e)));
    });
  }

  Future<void> saveSelected(BuildContext context) async {
    Navigator.pop(context, _selected);
  }

  Future<void> selectStorage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: storageList
                      .map(
                        (e) => ListTile(
                          title: Text(
                            FileManager.basename(e),
                          ),
                          onTap: () {
                            controller.openDirectory(e);
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
                ),
              );
            }
            return const Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Name"),
                onTap: () {
                  controller.sortBy(SortBy.name);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Size"),
                onTap: () {
                  controller.sortBy(SortBy.size);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Date"),
                onTap: () {
                  controller.sortBy(SortBy.date);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Type"),
                onTap: () {
                  controller.sortBy(SortBy.type);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
