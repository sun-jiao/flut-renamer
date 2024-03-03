import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../entity/constants.dart';
import '../l10n/l10n.dart';
import '../tools/ex_file.dart';

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

const _androidDir = '/sdcard/Android';

const _androidDirFull = '/storage/emulated/0/Android';

const _reserveDirs = [
  '/sdcard/DCIM',
  '/sdcard/DCIM/Camera',
  '/sdcard/Documents',
  '/sdcard/Download',
  '/sdcard/Movies',
  '/sdcard/Music',
  '/sdcard/Pictures',
  '/sdcard/Pictures/Screenshots',
  '/storage/emulated/0/DCIM',
  '/storage/emulated/0/DCIM/Camera',
  '/storage/emulated/0/Documents',
  '/storage/emulated/0/Download',
  '/storage/emulated/0/Movies',
  '/storage/emulated/0/Music',
  '/storage/emulated/0/Pictures',
  '/storage/emulated/0/Pictures/Screenshots',
];

/// Modified based on the example of library `file_manager`:
/// https://github.com/DevsOnFlutter/file_manager/blob/main/example/lib/main.dart
/// Originally distributed under BSD-3-Clause license
class AndroidFilePicker extends StatefulWidget {
  const AndroidFilePicker({super.key});

  @override
  State<AndroidFilePicker> createState() => _AndroidFilePickerState();
}

GlobalKey<State<StatefulBuilder>> _stfKey = GlobalKey<State<StatefulBuilder>>();

class _AndroidFilePickerState extends State<AndroidFilePicker> {
  final FileManagerController controller = FileManagerController();

  final List<FileSystemEntity> _selected = [];
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
              builder: (contextS, setStateS) => ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  FileSystemEntity entity = entities[index];
                  String basename = FileManager.basename(
                    entity,
                    showFileExtension: true,
                  );
                  bool entitySelected = _selected.contains(entity);
                  return MergeSemantics(
                    child: ListTile(
                      leading: getIcon(entity),
                      trailing: entitySelected ? const Icon(Icons.task_alt_outlined) : null,
                      title: Text(
                        basename,
                        semanticsLabel: L10n.current.semanticsFileManagerTitle(
                          getType(entity),
                          entitySelected.toString(),
                          basename.toFilenameSemanticLabel(),
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
                            if (entitySelected) {
                              _selected.remove(entity);
                            } else {
                              _selected.add(entity);
                            }
                          });
                        }
                      },
                      onLongPress: () async {
                        if (_reserveDirs.contains(entity.path) ||
                            entity.path.startsWith(_androidDir) ||
                            entity.path.startsWith(_androidDirFull)) {
                          Fluttertoast.showToast(msg: L10n.current.noSysDir);
                          return;
                        }

                        // select or unselect a file or a dir
                        setStateS(() {
                          if (entitySelected) {
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

  String getType(FileSystemEntity entity) {
    if (FileManager.isFile(entity)) {
      return 'File';
    }
    return 'Directory';
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          tooltip: L10n.current.fileManagerSortButton,
          onPressed: () => sort(context),
          icon: const Icon(Icons.sort_rounded),
        ),
        IconButton(
          tooltip: L10n.current.fileManagerStorageButton,
          onPressed: () => selectStorage(context),
          icon: const Icon(Icons.sd_storage_rounded),
        ),
        IconButton(
          tooltip: L10n.current.selectAll,
          onPressed: () => selectAll(),
          icon: const Icon(Icons.select_all_rounded),
        ),
        IconButton(
          tooltip: L10n.current.fileManagerSaveButton,
          onPressed: () => saveSelected(context),
          icon: Text(L10n.current.select),
        ),
        box,
      ],
      title: ValueListenableBuilder<String>(
        valueListenable: controller.titleNotifier,
        builder: (context, title, _) => Text(title),
      ),
      leading: IconButton(
        tooltip: L10n.current.fileManagerBackButton,
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          if (await controller.isRootDirectory()) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          } else {
            await controller.goToParentDirectory();
          }
        },
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String last = "${snapshot.data!.modified}".substring(0, 10);
          if (entity is File) {
            String size = FileManager.formatBytes(snapshot.data!.size);

            return Text(
              '$last $size',
              semanticsLabel: L10n.current.semanticsFileManagerSubtitle(last, size),
            );
          }
          return Text(
            last,
            semanticsLabel: L10n.current.semanticsFileManagerDirSubtitle(last),
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
                title: Text(L10n.current.fileSortName),
                onTap: () {
                  controller.sortBy(SortBy.name);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(L10n.current.fileSortSize),
                onTap: () {
                  controller.sortBy(SortBy.size);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(L10n.current.fileSortDate),
                onTap: () {
                  controller.sortBy(SortBy.date);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(L10n.current.fileSortType),
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
