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
}
