import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/sharedpref.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/main.dart';
import 'package:flut_renamer/pages/home_page.dart';
import 'package:flut_renamer/pages/files_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await L10n.load(const Locale('en'));
    SharedPreferences.setMockInitialValues({});
    await Shared.init();
  });

  testWidgets('toolbar updates the list and restores its setting after restart',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const RenamerApp(locale: Locale('en')));
    await tester.pump();
    expect(
      tester.widget<FilesPage>(find.byType(FilesPage)).showThumbnails,
      isFalse,
    );
    final button = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton && widget.tooltip == L10n.current.showThumbnails,
    );
    await tester.tap(button);
    await tester.pump();
    expect(
      tester.widget<FilesPage>(find.byType(FilesPage)).showThumbnails,
      isTrue,
    );
    expect(Shared.pref.getBool('show_thumbnails'), isTrue);

    await tester.pumpWidget(const SizedBox());
    await Shared.init();
    await tester.pumpWidget(const RenamerApp(locale: Locale('en')));
    await tester.pump();
    expect(
      tester.widget<FilesPage>(find.byType(FilesPage)).showThumbnails,
      isTrue,
    );
    expect(tester.widget<IconButton>(button).isSelected, isTrue);
    await tester.tap(button);
    await tester.pump();
    expect(
      tester.widget<FilesPage>(find.byType(FilesPage)).showThumbnails,
      isFalse,
    );
    expect(Shared.pref.getBool('show_thumbnails'), isFalse);
  });

  testWidgets('builds the localized app root with file-list theme colors',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const RenamerApp(locale: Locale('en')));
    await tester.pump();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.locale, const Locale('en'));
    expect(materialApp.supportedLocales, contains(const Locale('ar')));
    expect(find.byType(HomePage), findsOneWidget);

    final context = tester.element(find.byType(HomePage));
    final colors = Theme.of(context).extension<FileListColors>();
    expect(colors?.primaryColor, Colors.white);
    expect(colors?.secondaryColor, Colors.grey.shade100);
  });
}
