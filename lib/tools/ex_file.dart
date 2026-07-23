import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../tools/file_metadata.dart';

class FileEntity {
  final FileSystemEntity entity;
  bool selected;
  String? error;
  String? _newName;
  FileMetadata? _metadata;

  FileEntity(this.entity, {this.selected = false, this.error, String? newName}) : _newName = newName;

  String get path => entity.path;
  String get name => p.basename(path);
  String get directory => p.dirname(path);

  String get newName => _newName ?? name;
  set newName(String? val) => _newName = val;

  String get newPath => p.join(directory, newName);

  bool isNewNameDuplicate(List<FileEntity> others) {
    final myNewPath = newPath;
    return others.any((other) => other != this && other.newPath == myNewPath);
  }

  FileMetadata? get metadata => _metadata;

  Future<void> initMetadata() async {
    _metadata ??= FileMetadata(entity);
    if (!_metadata!.inited) {
      await _metadata!.init();
    }
  }

  bool existsSync() {
    if (Platform.isAndroid && path.startsWith('content://')) {
      return true; // Assume exists for SAF paths for now, or use metadata if available
    }
    return entity.existsSync();
  }

  Directory get parent => entity.parent;

  FileEntity get absolute => FileEntity(entity.absolute, selected: selected, error: error, newName: _newName);

  String fileOrDir([bool returnLink = false]) {
    FileSystemEntity file = entity;

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
  FileEntity toFileEntity() => FileEntity(toFileSystemEntity());
  FileSystemEntity toFileSystemEntity() => _toFileSystemEntity(this, (xFile) => xFile.path);
}

extension ExPlatformFile on PlatformFile {
  FileEntity toFileEntity() => FileEntity(toFileSystemEntity());
  FileSystemEntity toFileSystemEntity() => _toFileSystemEntity(this, (file) => file.path ?? '');
}

extension ExLink on Link {
  FileSystemEntity toFileSystemEntity() => _toFileSystemEntity(this, (link) => link.targetSync());
}

extension ExPathString on String {
  FileEntity toFileEntity() => FileEntity(toFileSystemEntity());
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
