import 'dart:typed_data';

import 'package:flut_renamer/tools/platform_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pickerChannel = MethodChannel('net.sunjiao.renamer/picker');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, null);
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
      if (call.method == 'dirAccess')
        return {
          'paths': <Object>['/tmp/a', 3]
        };
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
            'uris': ['one', 'two']
          });
          return {
            'candidates': ['one', 'one'],
            'approved': ['two']
          };
        case 'getMetaData':
          return {'size': 12};
        case 'readFile':
          return Uint8List.fromList([1, 2]);
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
        await PlatformFilePicker.readFile('uri'), Uint8List.fromList([1, 2]));
    expect(
        await PlatformFilePicker.getEmbeddedMetadata('uri'), {'artist': '4'});
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
    expect(await PlatformFilePicker.readFile('uri'), isNull);
    expect(await PlatformFilePicker.getEmbeddedMetadata('uri'), isEmpty);
  });

  test('forwards scoped access and URI rename calls to the native channel',
      () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pickerChannel, (call) async {
      if (call.method == 'changeScopedAccess') {
        expect(
            call.arguments, {'targetPath': '/tmp/folder', 'startOrEnd': true});
        return true;
      }
      if (call.method == 'rename') {
        expect(call.arguments, {'uri': 'content://item', 'newName': 'new.jpg'});
        return 'content://renamed-item';
      }
      return null;
    });

    expect(await PlatformFilePicker.changeScopedAccess('/tmp/folder', true),
        isTrue);
    expect(
      await PlatformFilePicker.rename('content://item', 'new.jpg'),
      'content://renamed-item',
    );
  });
}
