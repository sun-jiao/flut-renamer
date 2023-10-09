import 'package:flutter/material.dart';

import 'entity/sharedpref.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  while (!Shared.initialed) {
    await Shared.init();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renamer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      home: HomePage(),
    );
  }
}
