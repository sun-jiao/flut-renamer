import 'package:flutter/material.dart';

import 'entity/sharedpref.dart';
import 'entity/theme_extension.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MaterialApp(
      title: 'Renamer',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.pinkAccent,
        ),
        brightness: Brightness.light,
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[
          FileListColors(
            primaryColor: Colors.white,
            secondaryColor: Colors.grey.shade100,
          ),
        ],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.pinkAccent,
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[
          FileListColors(
            primaryColor: Colors.grey.shade900,
            secondaryColor: Colors.grey.shade800,
          ),
        ],
      ),
      home: SafeArea(
        child: HomePage(),
      ),
    );
  }
}
