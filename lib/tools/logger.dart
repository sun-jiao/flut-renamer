import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  Future<void>? _writeTask;

  Future<File> _getLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final logDir = Directory('${directory.path}/logs');
    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }
    return File('${logDir.path}/renamer_log.txt');
  }

  Future<void> logRename(String oldPath, String newPath) async {
    final task = (_writeTask ?? Future.value()).then((_) async {
      final file = await _getLogFile();
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final logEntry = '[$timestamp] RENAME: "$oldPath" -> "$newPath"\n';
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
}
