import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../tools/file_metadata.dart';

class ExtFieldHandler<T> {
  final Map<String, T> _values = {};

  T? getValue(String path) => _values[path];

  void setValue(String path, T? value) {
    if (value != null) {
      _values[path] = value;
    } else {
      _values.remove(path);
    }
  }

  void clearValues() => _values.clear();

  bool checkDuplicatedPath(String path, T value) =>
      _values.entries.where((e) => e.key != path && p.join(p.dirname(path), value.toString()) == p.join(p.dirname(e.key), e.value.toString())).isNotEmpty;
}

// an extension to control file list selection.
extension ExFile on FileSystemEntity {
  // get file name
  String get name => p.basename(path);

  // get the directory
  String get directory => p.dirname(path);

  static final ExtFieldHandler<bool> _selectionHandler = ExtFieldHandler();
  bool get selected => _selectionHandler.getValue(path) ?? false;
  set selected(bool? val) => _selectionHandler.setValue(path, val);
  static void clearSelections() => _selectionHandler.clearValues();

  static final ExtFieldHandler<String> _errorHandler = ExtFieldHandler();
  String? get error => _errorHandler.getValue(path);
  set error(String? val) => _errorHandler.setValue(path, val);
  static void clearErrors() => _errorHandler.clearValues();

  static final ExtFieldHandler<String> _newNameHandler = ExtFieldHandler();
  String get newName => _newNameHandler.getValue(path) ?? name;
  set newName(String? val) => _newNameHandler.setValue(path, val);
  static void clearNewNames() => _newNameHandler.clearValues();

  bool get newNameDuplicate => _newNameHandler.checkDuplicatedPath(path, newName);
  String get newPath => p.join(directory, newName);

  static final ExtFieldHandler<FileMetadata> _metadataHandler = ExtFieldHandler();
  FileMetadata? get metadata => _metadataHandler.getValue(path);
  void initMetadata() async {
    if (metadata == null) {
      _metadataHandler.setValue(path, FileMetadata(this));
    }
    if (!metadata!.inited) {
      await metadata!.init();
    }
  }
  static void clearMetadata() => _metadataHandler.clearValues();

  String fileOrDir([bool returnLink=false]) {
    FileSystemEntity file = this;

    while (file is Link) {
      if (returnLink) {
        return 'Link';
      } else {
        file = file.toFileSystemEntity();
      }
    }

    if (file is File) {
      return 'File';
    } else if (file is Directory) {
      return 'Dir';
    }

    return 'Renamer'; // Meaningless String to not contained by `_type`
  }
}

extension ExXFile on XFile {
  FileSystemEntity toFileSystemEntity() => _toFileSystemEntity(this, (xFile) => xFile.path);
}

extension ExPlatformFile on PlatformFile {
  FileSystemEntity toFileSystemEntity() => _toFileSystemEntity(this, (file) => file.path ?? '');
}

extension ExLink on Link {
  FileSystemEntity toFileSystemEntity() => _toFileSystemEntity(this, (link) => link.targetSync());
}

extension ExPathString on String {
  FileSystemEntity toFileSystemEntity() => _toFileSystemEntity(this, (str) => str);

  // usually causes the talkback to choose a wrong language.
  String toFilenameSemanticLabel() => RegExp(r'([a-zA-Z]+|\d.{0,3}|[^a-zA-Z0-9]+)').allMatches(this).map((e) => e.group(0)).join('，');
}

FileSystemEntity _toFileSystemEntity<T>(T file, String Function(T file) func) {
  FileSystemEntity entity;

  entity = File(func.call(file));
  if (!entity.existsSync()) entity = Directory(func.call(file));
  if (!entity.existsSync()) entity = Link(func.call(file));

  return entity;
}
