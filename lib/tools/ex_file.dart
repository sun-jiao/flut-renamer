import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../tools/file_metadata.dart';
import '../tools/platform_channel.dart';

/// The small subset of file metadata needed to sort the file list.
///
/// This is deliberately separate from [FileMetadata], whose initialization
/// also reads EXIF and audio tags. Sorting a large list only needs these two
/// values.
class FileSortMetadata {
  const FileSortMetadata({
    required this.size,
    required this.modified,
  });

  final int? size;
  final DateTime? modified;
}

class FileEntity {
  final FileSystemEntity entity;
  bool selected;
  String? error;
  String? _newName;
  FileMetadata? _metadata;
  Future<void>? _metadataLoad;
  FileSortMetadata? _sortMetadata;
  Future<void>? _sortMetadataLoad;

  FileEntity(this.entity, {this.selected = false, this.error, String? newName})
      : _newName = newName;

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

  /// Creates the lazy metadata object without performing I/O. Rules can pass
  /// this to one another and initialize it only when a tag is actually used.
  FileMetadata get metadataForRename => _metadata ??= FileMetadata(entity);
  FileSortMetadata? get sortMetadata => _sortMetadata;

  /// Initializes metadata at most once, even when several rows request it
  /// during the same build.
  Future<void> initMetadata() async {
    _metadata ??= FileMetadata(entity);
    if (_metadata!.inited) return;

    final initialization = _metadataLoad ??= _metadata!.init();
    try {
      await initialization;
    } finally {
      if (identical(_metadataLoad, initialization)) {
        _metadataLoad = null;
      }
    }
  }

  /// Loads only the values used by size/date sorting and retains them for the
  /// lifetime of this entity. In particular, SAF URIs must use the Android
  /// metadata channel instead of Dart's file-system APIs.
  Future<void> preloadSortMetadata() {
    return _sortMetadataLoad ??= _loadSortMetadata();
  }

  Future<void> _loadSortMetadata() async {
    try {
      if (Platform.isAndroid && path.startsWith('content://')) {
        final metadata = await PlatformFilePicker.getMetaData(path);
        _sortMetadata = FileSortMetadata(
          size: _metadataInt(metadata?['size']),
          modified: _metadataDate(metadata?['modified']),
        );
      } else {
        final stat = await entity.stat();
        _sortMetadata = FileSortMetadata(
          size: stat.size,
          modified: stat.modified,
        );
      }
    } on FileSystemException {
      // A file can disappear while its list entry is still visible. Leave its
      // sort metadata unavailable so the comparator uses its name as a tie.
    }
  }

  int? _metadataInt(Object? value) => switch (value) {
        int value => value,
        num value => value.toInt(),
        _ => null,
      };

  DateTime? _metadataDate(Object? value) {
    final milliseconds = _metadataInt(value);
    return milliseconds == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  bool existsSync() {
    if (Platform.isAndroid && path.startsWith('content://')) {
      return true; // Assume exists for SAF paths for now, or use metadata if available
    }
    return entity.existsSync();
  }

  Directory get parent => entity.parent;

  FileEntity get absolute => FileEntity(
        entity.absolute,
        selected: selected,
        error: error,
        newName: _newName,
      );

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
  FileSystemEntity toFileSystemEntity() =>
      _toFileSystemEntity(this, (xFile) => xFile.path);
}

extension ExPlatformFile on PlatformFile {
  FileEntity toFileEntity() => FileEntity(toFileSystemEntity());
  FileSystemEntity toFileSystemEntity() =>
      _toFileSystemEntity(this, (file) => file.path ?? '');
}

extension ExLink on Link {
  FileSystemEntity toFileSystemEntity() =>
      _toFileSystemEntity(this, (link) => link.targetSync());
}

extension ExPathString on String {
  FileEntity toFileEntity() => FileEntity(toFileSystemEntity());
  FileSystemEntity toFileSystemEntity() =>
      _toFileSystemEntity(this, (str) => str);

  // usually causes the talkback to choose a wrong language.
  String toFilenameSemanticLabel() =>
      RegExp(r'([a-zA-Z]+|\d.{0,3}|[^a-zA-Z0-9]+)')
          .allMatches(this)
          .map((e) => e.group(0))
          .join('，');
}

FileSystemEntity _toFileSystemEntity<T>(T file, String Function(T file) func) {
  FileSystemEntity entity;

  entity = File(func.call(file));
  if (!entity.existsSync()) entity = Directory(func.call(file));
  if (!entity.existsSync()) entity = Link(func.call(file));

  return entity;
}
