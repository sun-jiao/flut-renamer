import 'dart:async';
import 'dart:io';

import 'package:flut_renamer/tools/ex_file.dart';
import 'package:flut_renamer/widget/file_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('net.sunjiao.renamer/picker');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets(
      'local images decode at thumbnail size and missing images fall back',
      (tester) async {
    Future<ImageInfo?> show(String path) async {
      return tester.runAsync<ImageInfo?>(() async {
        await tester.pumpWidget(
          MaterialApp(home: FileThumbnail(file: FileEntity(File(path)))),
        );
        final provider = tester.widget<Image>(find.byType(Image)).image;
        final completed = Completer<ImageInfo?>();
        final stream = provider.resolve(ImageConfiguration.empty);
        final listener = ImageStreamListener(
          (image, _) => completed.complete(image),
          onError: (_, stack) => completed.complete(null),
        );
        stream.addListener(listener);
        try {
          final info =
              await completed.future.timeout(const Duration(seconds: 10));
          await tester.pump();
          return info;
        } finally {
          stream.removeListener(listener);
        }
      });
    }

    final info = await show('assets/icon.png');
    expect(info, isNotNull);
    expect(info!.image.width, lessThanOrEqualTo(168));
    expect(info.image.height, lessThanOrEqualTo(168));
    info.dispose();
    expect(await show('/missing/photo.jpg'), isNull);
    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'directories and other files use placeholders without image reads',
      (tester) async {
    var calls = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls++;
      return null;
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Row(
          children: [
            FileThumbnail(
              file: FileEntity(Directory('content://provider/tree/1')),
            ),
            FileThumbnail(file: FileEntity(File('/missing/document.txt'))),
          ],
        ),
      ),
    );
    expect(find.byIcon(Icons.folder_outlined), findsOneWidget);
    expect(find.byIcon(Icons.insert_drive_file_outlined), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(calls, 0);
  });

  testWidgets('SAF previews are cached per row and refreshed for changed URIs',
      (tester) async {
    final requests = <String>[];
    final bytes = File('assets/icon.png').readAsBytesSync();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getThumbnail');
      requests.add(call.arguments['uri'] as String);
      return bytes;
    });
    Future<void> show(String uri) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FileThumbnail(file: FileEntity(File(uri))),
        ),
      );
      await tester.pump();
    }

    await show('content://provider/document/1');
    expect(find.byType(Image), findsOneWidget);
    await show('content://provider/document/1');
    expect(requests, ['content://provider/document/1']);
    await show('content://provider/document/2');
    expect(requests, [
      'content://provider/document/1',
      'content://provider/document/2',
    ]);
  });

  testWidgets('unreadable SAF previews do not break the list', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'UNREADABLE');
    });
    await tester.pumpWidget(
      MaterialApp(
        home:
            FileThumbnail(file: FileEntity(File('content://provider/missing'))),
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.insert_drive_file_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
