import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'entity/sharedpref.dart';
import 'entity/theme_extension.dart';
import 'l10n/l10n.dart';
import 'pages/home_page.dart';
import 'widget/custom_dialog.dart';

late Locale _appLocale;

Locale _getLocale() {
  final localeNames = Platform.localeName.split(RegExp('[_-]'));
  return Locale(localeNames[0], localeNames.length > 1 ? localeNames[1] : null);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _appLocale = _getLocale();
  L10n.load(_appLocale);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

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
      title: L10n.current.appName,
      themeMode: ThemeMode.system,
      locale: _appLocale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: Platform.isWindows ? "微软雅黑" : null, // fixed Chinese font rendering error
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xff9cdce8),
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
        fontFamily: Platform.isWindows ? "微软雅黑" : null, // fixed Chinese font rendering error
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xff26546e),
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
    if (Platform.isAndroid) {
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
  }

  void _permissionRequest(BuildContext context) => showDialog(
        context: context,
        builder: (contextD) => CustomDialog(
          title: Text(L10n.current.permissionTitle),
          content: Text(L10n.current.permissionContent),
          actions: [
            TextButton(
              onPressed: () => _cannotRun(contextD),
              child: Text(L10n.current.exit),
            ),
            TextButton(
              onPressed: () => Permission.manageExternalStorage.request().isGranted.then((value) {
                if (value) {
                  Navigator.pop(contextD);
                }
              }),
              child: Text(L10n.current.ok),
            ),
          ],
        ),
      );

  void _cannotRun(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: Text(L10n.current.exitTitle),
        content: Text(L10n.current.exitContent),
        actions: [
          TextButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text(L10n.current.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _permissionCheck(context);

    return Semantics(
      child: HomePage(),
    );
  }
}
