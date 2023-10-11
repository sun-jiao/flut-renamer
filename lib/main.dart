import 'package:flutter/material.dart';
import 'package:renamer/entity/theme_extension.dart';
import 'package:yaru/yaru.dart';

import 'entity/sharedpref.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  while (!Shared.initialed) {
    await Shared.init();
  }
  runApp(const RenamerApp());
}

class RenamerApp extends StatelessWidget {
  const RenamerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      data: const YaruThemeData(
        variant: YaruVariant.ubuntuButterflyPink,
      ),
      builder: (context, yaru, child) {
        return MaterialApp(
          title: 'Renamer',
          theme: yaru.theme?.copyWith(
            extensions: <ThemeExtension<dynamic>>[
              FileListColors(
                primaryColor: Colors.white,
                secondaryColor: Colors.grey.shade100,
              ),
            ],
          ),
          darkTheme: yaru.darkTheme?.copyWith(
            extensions: <ThemeExtension<dynamic>>[
              FileListColors(
                primaryColor: Colors.grey.shade900,
                secondaryColor: Colors.grey.shade800,
              ),
            ],
          ),
          home: HomePage(),
        );
      },
    );
  }
}
