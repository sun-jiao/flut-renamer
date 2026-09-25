import 'dart:io';

import 'package:flut_renamer/tools/platform_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pickerChannel = MethodChannel('net.sunjiao.renamer/picker');

  test(
      'creation-time channel converts epoch milliseconds and preserves absence',
      () async {
    for (final milliseconds in [0, 1712345678901, null]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pickerChannel, (call) async {
        expect(call.method, 'getCreationTime');
        expect(call.arguments, {'path': '/folder/file'});
        return milliseconds;
      });
      expect(
        (await PlatformFilePicker.getCreationTime('/folder/file'))
            ?.millisecondsSinceEpoch,
        milliseconds,
      );
    }
  });

  test('unavailable creation-time channel leaves metadata empty', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (_) async {
      throw PlatformException(code: 'ACCESS_DENIED');
    });
    expect(await PlatformFilePicker.getCreationTime('/folder/file'), isNull);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, null);
    expect(await PlatformFilePicker.getCreationTime('/folder/file'), isNull);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, null);
  });

  test(
      'coordinated rename returns the provider path and preserves native errors',
      () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async {
      expect(call.method, 'coordinatedRename');
      expect(
        call.arguments,
        {'source': '/folder/a', 'destination': '/folder/b'},
      );
      return '/provider/b';
    });
    expect(
      await PlatformFilePicker.coordinatedRename('/folder/a', '/folder/b'),
      '/provider/b',
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async {
      throw PlatformException(
        code: 'RENAME_FAILED',
        message: 'File exists',
        details: {'domain': 'NSPOSIXErrorDomain', 'code': 17},
      );
    });
    await expectLater(
      PlatformFilePicker.coordinatedRename('/folder/a', '/folder/b'),
      throwsA(
        isA<FileSystemException>()
            .having((e) => e.osError?.errorCode, 'native error', 17),
      ),
    );
  });

  test('coordinated rename never treats an empty native response as success',
      () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (_) async => null);
    await expectLater(
      PlatformFilePicker.coordinatedRename('/folder/a', '/folder/b'),
      throwsA(isA<FileSystemException>()),
    );
  });

  test('scope reconciliation passes remaining paths and allows releasing all',
      () async {
    final retained = <List<dynamic>>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async {
      expect(call.method, 'retainScopedAccess');
      retained.add((call.arguments as Map)['paths'] as List);
      return null;
    });
    await PlatformFilePicker.retainScopedAccess(['/folder/sub/file']);
    await PlatformFilePicker.retainScopedAccess([]);
    expect(retained, [
      ['/folder/sub/file'],
      [],
    ]);
  });

  testWidgets('fileAccess accepts iOS path-list responses', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      pickerChannel,
      (call) async {
        expect(call.method, 'fileAccess');
        expect(call.arguments, {'startPath': '/tmp'});
        return <String>['/tmp/first.txt', '/tmp/second.txt'];
      },
    );

    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(
      await PlatformFilePicker.fileAccess(context, '/tmp'),
      ['/tmp/first.txt', '/tmp/second.txt'],
    );
  });

  testWidgets('fileAccess accepts Android map responses', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      pickerChannel,
      (call) async => {
        'paths': <String>['/tmp/first.txt'],
        'hasUnsupportedFiles': false,
      },
    );

    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(
      await PlatformFilePicker.fileAccess(context, '/tmp'),
      ['/tmp/first.txt'],
    );
  });

  test('dirAccess accepts both native response shapes and rejects invalid data',
      () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async {
      if (call.method == 'dirAccess') {
        return {
          'paths': <Object>['/tmp/a', 3],
        };
      }
      return null;
    });
    expect(await PlatformFilePicker.dirAccess(), ['/tmp/a']);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async => 42);
    await expectLater(
      PlatformFilePicker.dirAccess(),
      throwsA(isA<PlatformException>()),
    );
  });

  test('maps media permission and metadata channel values', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async {
      switch (call.method) {
        case 'requestMediaWritePermission':
          expect(call.arguments, {
            'uris': ['one', 'two'],
          });
          return {
            'candidates': ['one', 'one'],
            'approved': ['two'],
          };
        case 'getMetaData':
          return {'size': 12};
        case 'getEmbeddedMetadata':
          return {'artist': 4};
      }
      return null;
    });

    final permission =
        await PlatformFilePicker.requestMediaWritePermission(['one', 'two']);
    expect(permission.candidates, {'one'});
    expect(permission.approved, {'two'});
    expect(await PlatformFilePicker.getMetaData('uri'), {'size': 12});
    expect(
      await PlatformFilePicker.getEmbeddedMetadata('uri'),
      {'artist': '4'},
    );
  });

  test('uses safe empty values when optional native calls fail', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      pickerChannel,
      (call) async => throw PlatformException(code: 'DENIED'),
    );

    expect(
      await PlatformFilePicker.requestMediaWritePermission(['uri']),
      isA<MediaWritePermission>()
          .having((value) => value.candidates, 'candidates', isEmpty)
          .having((value) => value.approved, 'approved', isEmpty),
    );
    expect(await PlatformFilePicker.getMetaData('uri'), isNull);
    expect(await PlatformFilePicker.getEmbeddedMetadata('uri'), isEmpty);
  });

  test('forwards scoped access and URI rename calls to the native channel',
      () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async {
      if (call.method == 'changeScopedAccess') {
        expect(
          call.arguments,
          {'targetPath': '/tmp/folder', 'startOrEnd': true},
        );
        return true;
      }
      if (call.method == 'rename') {
        expect(call.arguments, {'uri': 'content://item', 'newName': 'new.jpg'});
        return 'content://renamed-item';
      }
      return null;
    });

    expect(
      await PlatformFilePicker.changeScopedAccess('/tmp/folder', true),
      isTrue,
    );
    expect(
      await PlatformFilePicker.rename('content://item', 'new.jpg'),
      'content://renamed-item',
    );
  });
}
