import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../entity/constants.dart';
import '../entity/sharedpref.dart';
import '../rules/rule.dart';
import '../tools/file_metadata.dart';
import '../tools/responsive.dart';
import 'rules_page.dart';
import 'files_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<FilesPageState> filesKey = GlobalKey<FilesPageState>();
  final GlobalKey<RulesPageState> rulesKey = GlobalKey<RulesPageState>();

  @override
  Widget build(BuildContext context) {
    final filesPage = FilesPage(
      key: filesKey,
      getNewName: (String name, FileMetadata metadata) async {
        for (Rule rule in rulesKey.currentState?.rules ?? []) {
          name = await rule.newName(name, metadata: metadata);
        }
        return name;
      },
      resetRules: () {
        for (final rule in rulesKey.currentState?.rules ?? []) {
          if (rule is RuleIncrement) {
            rule.indexReset();
          }
        }
      },
      clearRules: () {
        rulesKey.currentState?.clearRule();
      },
    );

    final rulesPage = RulesPage(
      key: rulesKey,
      onRuleChanged: () {
        filesKey.currentState?.update();
      },
    );

    return Scaffold(
      bottomNavigationBar: HomeToolBar(
        onlySelectedCallback: (value) => Shared.onlySelected = value,
        onlySelectedValue: () => Shared.onlySelected,
        removeRenamedCallback: (value) => Shared.removeRenamed = value,
        removeRenamedValue: () => Shared.removeRenamed,
        removeRulesCallback: (value) => Shared.removeRules = value,
        removeRulesValue: () => Shared.removeRules,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          filesKey.currentState?.renameFiles(
            remove: Shared.removeRenamed,
            onlySelected: Shared.onlySelected,
          );
        },
        tooltip: "Rename",
        child: const Icon(Icons.play_arrow_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Responsive(
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: filesPage,
              ),
              Expanded(
                child: rulesPage,
              ),
            ],
          ),
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: filesPage,
              ),
              Expanded(
                child: rulesPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeToolBar extends StatefulWidget {
  const HomeToolBar({
    super.key,
    required this.onlySelectedCallback,
    required this.onlySelectedValue,
    required this.removeRenamedCallback,
    required this.removeRenamedValue,
    required this.removeRulesCallback,
    required this.removeRulesValue,
  });

  final void Function(bool) onlySelectedCallback;
  final bool Function() onlySelectedValue;

  final void Function(bool) removeRenamedCallback;
  final bool Function() removeRenamedValue;

  final void Function(bool) removeRulesCallback;
  final bool Function() removeRulesValue;

  @override
  State<HomeToolBar> createState() => _HomeToolBarState();
}

class _HomeToolBarState extends State<HomeToolBar> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    bool expanded = !isMobile;

    return BottomAppBar(
      height: isMobile ? 64 : null,
      padding: const EdgeInsets.all(8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 64),
        children: [
          IconButton(
            tooltip: 'App info',
            icon: const Icon(Icons.info_rounded),
            onPressed: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              if (!mounted) {
                return;
              }

              showAboutDialog(
                context: context,
                applicationName: packageInfo.appName,
                applicationVersion: packageInfo.version,
                applicationIcon: Image.asset(
                  'assets/ic_launcher.png',
                  width: 48,
                ),
                applicationLegalese: 'GPL-3.0',
                children: [
                  const Text(
                      'This application is designed to help users rename their files. It is built with Flutter - a multi-platform application framework, and therefore it is also available on other operating systems. It is totally open source and could be reviewed or contributed to.'),
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Rating the app',
            icon: const Icon(Icons.star_rate_rounded),
            onPressed: ratingMyApp,
          ),
          IconButton(
            tooltip: 'Source code',
            icon: const Icon(Icons.code_rounded),
            onPressed: gotoGithub,
          ),
          if (isMobile)
            IconButton(
              tooltip: expanded ? 'Collapse options' : 'Expand options',
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon: Icon(
                expanded ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            ),
          box,
          if (expanded)
            FilterChip(
              label: const Text('Only Selected'),
              onSelected: (value) => setState(() {
                widget.onlySelectedCallback.call(value);
              }),
              selected: widget.onlySelectedValue.call(),
            ),
          if (expanded) box,
          if (expanded)
            FilterChip(
              label: const Text('Remove renamed'),
              onSelected: (value) => setState(() {
                widget.removeRenamedCallback.call(value);
              }),
              selected: widget.removeRenamedValue.call(),
            ),
          if (expanded) box,
          if (expanded)
            FilterChip(
              label: const Text('Remove rules after renaming'),
              onSelected: (value) => setState(() {
                widget.removeRulesCallback.call(value);
              }),
              selected: widget.removeRulesValue.call(),
            ),
          if (expanded) box,
        ],
      ),
    );
  }

  void ratingMyApp() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Rate Our App'),
          content: const Text(
            'Enjoying our app? Help us grow by giving it a quick rating on the store or GitHub. Your feedback means the world to us! Thank you for your support.',
          ),
          actions: [
            if (Platform.isAndroid)
              TextButton(
                onPressed: () {
                  const appId = 'net.sunjiao.renamer';
                  final url = Uri.parse("market://details?id=$appId");
                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text('Rate the app on store'),
              ),
            TextButton(
              onPressed: gotoGithub,
              child: const Text('Star it on Github'),
            ),
          ],
        ),
      );

  void gotoGithub() {
    final url = Uri.parse("https://github.com/sun-jiao/renamer");
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
