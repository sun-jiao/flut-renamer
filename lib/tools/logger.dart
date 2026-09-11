import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal()
      : _directoryProvider = getApplicationCacheDirectory,
        _maxLogBytes = _defaultMaxLogBytes;

  /// Creates an isolated logger for tests.
  Logger.forTesting(
    this._directoryProvider, {
    int maxLogBytes = _defaultMaxLogBytes,
  }) : _maxLogBytes = maxLogBytes;

  static const _defaultMaxLogBytes = 1024 * 1024;
  static const _archivedLogCount = 2;

  final Future<Directory> Function() _directoryProvider;
  final int _maxLogBytes;

  Future<void>? _writeTask;

  Future<File> _getLogFile() async {
    // Cache storage is excluded from Android Auto Backup and iOS device
    // backups, unlike the application documents directory. Rename logs may
    // include sensitive file names, so they should not be retained there.
    final directory = await _directoryProvider();
    final logDir = Directory('${directory.path}/logs');
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }
    return File('${logDir.path}/renamer_log.txt');
  }

  Future<void> logRename(String oldPath, String newPath) async {
    // Keep the queue usable when an earlier write failed. The previous task is
    // still returned to its caller with its original error, but later writes
    // start after that error has been handled here.
    final previousTask = (_writeTask ?? Future<void>.value()).catchError(
      (Object _, StackTrace __) {},
    );
    final task = previousTask.then((_) async {
      final file = await _getLogFile();
      final timestamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final logEntry = '[$timestamp] RENAME: "$oldPath" -> "$newPath"\n';
      await _rotateIfNeeded(file, utf8.encode(logEntry).length);
      await file.writeAsString(logEntry, mode: FileMode.append, flush: true);
    });
    _writeTask = task;
    return task;
  }

  Future<String> getLogPath() async {
    final file = await _getLogFile();
    return file.path;
  }

  Future<String> readLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }

  /// Deletes the active and rotated audit logs.
  Future<void> clearLogs() {
    final previousTask = (_writeTask ?? Future<void>.value()).catchError(
      (Object _, StackTrace __) {},
    );
    final task = previousTask.then((_) async {
      final file = await _getLogFile();
      for (var index = 0; index <= _archivedLogCount; index++) {
        final candidate = index == 0
            ? file
            : File('${file.parent.path}/renamer_log.$index.txt');
        if (await candidate.exists()) await candidate.delete();
      }
    });
    _writeTask = task;
    return task;
  }

  Future<void> _rotateIfNeeded(File file, int pendingBytes) async {
    if (!await file.exists()) return;
    final existingBytes = await file.length();
    if (existingBytes + pendingBytes <= _maxLogBytes) {
      return;
    }

    final directory = file.parent;
    final oldest = File('${directory.path}/renamer_log.$_archivedLogCount.txt');
    if (await oldest.exists()) await oldest.delete();
    for (var index = _archivedLogCount - 1; index >= 1; index--) {
      final archived = File('${directory.path}/renamer_log.$index.txt');
      if (await archived.exists()) {
        await archived.rename('${directory.path}/renamer_log.${index + 1}.txt');
      }
    }
    await file.rename('${directory.path}/renamer_log.1.txt');
  }
}
