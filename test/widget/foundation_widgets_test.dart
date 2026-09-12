import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/theme_extension.dart';
import 'package:flut_renamer/tools/responsive.dart';

void main() {
  testWidgets('Responsive selects mobile below the width breakpoint',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(749, 600)),
          child: Responsive(
            mobile: Text('mobile'),
            desktop: Text('desktop'),
          ),
        ),
      ),
    );

    expect(find.text('mobile'), findsOneWidget);
    expect(find.text('desktop'), findsNothing);
  });

  testWidgets('Responsive selects desktop at the width breakpoint',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(750, 600)),
          child: Responsive(
            mobile: Text('mobile'),
            desktop: Text('desktop'),
          ),
        ),
      ),
    );

    expect(find.text('desktop'), findsOneWidget);
    expect(find.text('mobile'), findsNothing);
  });

  test('FileListColors preserves unspecified colors and interpolates colors',
      () {
    final source = FileListColors(
      primaryColor: Colors.black,
      secondaryColor: Colors.white,
    );
    final target = FileListColors(
      primaryColor: Colors.red,
      secondaryColor: Colors.blue,
    );

    final copied =
        source.copyWith(primaryColor: Colors.green) as FileListColors;
    final interpolated = source.lerp(target, .5) as FileListColors;

    expect(copied.primaryColor, Colors.green);
    expect(copied.secondaryColor, Colors.white);
    expect(interpolated.primaryColor, Color.lerp(Colors.black, Colors.red, .5));
    expect(
      interpolated.secondaryColor,
      Color.lerp(Colors.white, Colors.blue, .5),
    );
    expect(source.lerp(null, .5), same(source));
  });
}
