import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/logger.dart';

void main() {
  late Directory temporaryDirectory;
  late Logger logger;

  setUp(() async {
    temporaryDirectory =
        await Directory.systemTemp.createTemp('renamer_logger_');
    logger = Logger.forTesting(() async => temporaryDirectory, maxLogBytes: 80);
  });

  tearDown(() => temporaryDirectory.delete(recursive: true));

  test('rotates logs before they grow past the configured limit', () async {
    await logger.logRename('old-path-that-fills-the-log', 'new-path');
    await logger.logRename('second-old-path-that-fills-the-log', 'second-new');

    final logDirectory = Directory('${temporaryDirectory.path}/logs');
    final activeLog = File('${logDirectory.path}/renamer_log.txt');
    final archivedLog = File('${logDirectory.path}/renamer_log.1.txt');
    expect(await archivedLog.readAsString(), contains('old-path-that-fills'));
    expect(await activeLog.readAsString(), contains('second-old-path'));
  });

  test('clears active and rotated logs', () async {
    await logger.logRename('old-path-that-fills-the-log', 'new-path');
    await logger.logRename('second-old-path-that-fills-the-log', 'second-new');

    await logger.clearLogs();

    expect(await logger.readLogs(), isEmpty);
    expect(
      await File('${temporaryDirectory.path}/logs/renamer_log.1.txt').exists(),
      isFalse,
    );
  });

  test('keeps only the two newest archived logs', () async {
    for (var index = 0; index < 4; index++) {
      await logger.logRename(
          'old-path-$index-that-fills-the-log', 'new-$index');
    }

    final logDirectory = Directory('${temporaryDirectory.path}/logs');
    expect(
        await File('${logDirectory.path}/renamer_log.1.txt').exists(), isTrue);
    expect(
        await File('${logDirectory.path}/renamer_log.2.txt').exists(), isTrue);
    expect(
        await File('${logDirectory.path}/renamer_log.3.txt').exists(), isFalse);
    expect(await logger.getLogPath(), '${logDirectory.path}/renamer_log.txt');
  });
}
