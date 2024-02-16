import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'entity/sharedpref.dart';
import 'entity/theme_extension.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

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
      debugShowCheckedModeBanner: false,
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
      home: const AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  void _permissionCheck(BuildContext context) async {
    if (!Platform.isAndroid) {
      return;
    }

    final PermissionStatus value = await Permission.manageExternalStorage.status;

    switch (value) {
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          _cannotRun(context);
        }
      case PermissionStatus.denied:
        if (context.mounted) {
          _permissionRequest(context);
        }
      default:
        return;
    }
  }

  void _permissionRequest(BuildContext context) => showDialog(
        context: context,
        builder: (contextD) => AlertDialog(
          title: const Text("Permission for external storage"),
          content: const Text(
            "To provide you with our file renaming service, we need your permission to manage external storage. This allows us to access and rename files stored on your device. Without this permission, the app won't be able to access the complete file paths and therefore can't rename files. We assure you that your privacy and security are our top priorities, and we only access files for the purpose of renaming.",
          ),
          actions: [
            TextButton(
              onPressed: () => _cannotRun(contextD),
              child: const Text("Exit"),
            ),
            TextButton(
              onPressed: () => Permission.manageExternalStorage.request().isGranted.then((value) {
                if (value) {
                  Navigator.pop(contextD);
                }
              }),
              child: const Text("OK"),
            ),
          ],
        ),
      );

  void _cannotRun(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Can not access external storage"),
        content: const Text(
          "The manage external storage permission allows us to access and rename files stored on your device. Without this permission, the app won't be able to access the complete file paths and therefore can't rename files. Please go to Settings page and grant the permission manually, otherwise we cannot provide any service.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _permissionCheck(context);

    return HomePage();
  }
}
