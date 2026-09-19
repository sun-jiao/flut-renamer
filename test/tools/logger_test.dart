import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/tools/logger.dart';
import 'package:intl/intl.dart';

void main() {
  late Directory temporaryDirectory;
  late Logger logger;

  setUp(() async {
    temporaryDirectory =
        await Directory.systemTemp.createTemp('renamer_logger_');
    logger = Logger.forTesting(() async => temporaryDirectory, maxLogBytes: 80);
  });

  tearDown(() => temporaryDirectory.delete(recursive: true));

  test('writes numeric timestamps without initialized locale data', () async {
    final previous = Intl.defaultLocale;
    Intl.defaultLocale = 'zz_ZZ';
    try {
      await logger.logRename('before', 'after');
      expect(
        await logger.readLogs(),
        matches(
          r'^\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\] RENAME: "before" -> "after"\n$',
        ),
      );
    } finally {
      Intl.defaultLocale = previous;
    }
  });

  test('readLogs waits for pending writes', () async {
    final pending = logger.logRename('before', 'after');
    expect(await logger.readLogs(), contains('"before" -> "after"'));
    await pending;
  });

  test('failed write does not strand the queue across error zones', () async {
    var fail = true;
    final isolated = Logger.forTesting(() async {
      if (fail) throw const FileSystemException('injected failure');
      return temporaryDirectory;
    });
    final uncaught = <Object>[];
    await runZonedGuarded(
      () async {
        await expectLater(
          isolated.logRename('bad', 'bad'),
          throwsA(isA<FileSystemException>()),
        );
      },
      (error, stack) => uncaught.add(error),
    );
    fail = false;
    await isolated
        .logRename('good', 'after')
        .timeout(const Duration(seconds: 2));
    expect(await isolated.readLogs(), contains('"good" -> "after"'));
    expect(uncaught, isEmpty);
  });

  test('failed queued write is reported and later writes still work', () async {
    var fail = true;
    final isolated = Logger.forTesting(() async {
      if (fail) throw const FileSystemException('injected log failure');
      return temporaryDirectory;
    });
    await expectLater(
      isolated.logRename('bad', 'bad'),
      throwsA(isA<FileSystemException>()),
    );
    await isolated.flush();
    fail = false;
    await isolated.logRename('good', 'after');
    expect(await isolated.readLogs(), contains('"good" -> "after"'));
  });

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
        'old-path-$index-that-fills-the-log',
        'new-$index',
      );
    }

    final logDirectory = Directory('${temporaryDirectory.path}/logs');
    expect(
      await File('${logDirectory.path}/renamer_log.1.txt').exists(),
      isTrue,
    );
    expect(
      await File('${logDirectory.path}/renamer_log.2.txt').exists(),
      isTrue,
    );
    expect(
      await File('${logDirectory.path}/renamer_log.3.txt').exists(),
      isFalse,
    );
    expect(await logger.getLogPath(), '${logDirectory.path}/renamer_log.txt');
  });
}
