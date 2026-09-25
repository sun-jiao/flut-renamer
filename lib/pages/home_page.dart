import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../entity/constants.dart';
import '../entity/sharedpref.dart';
import '../l10n/l10n.dart';
import '../rules/rule.dart';
import '../tools/app_haptics.dart';
import '../tools/file_metadata.dart';
import '../tools/logger.dart';
import '../tools/responsive.dart';
import '../widget/custom_dialog.dart';
import 'rules_page.dart';
import 'files_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FilesPageState> filesKey = GlobalKey<FilesPageState>();
  final GlobalKey<RulesPageState> rulesKey = GlobalKey<RulesPageState>();
  bool _renaming = false;

  @override
  Widget build(BuildContext context) {
    final filesPage = FilesPage(
      key: filesKey,
      onRenamingChanged: (value) {
        if (mounted) setState(() => _renaming = value);
      },
      showThumbnails: Shared.showThumbnails,
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
      dependsOnFileOrder: () => (rulesKey.currentState?.rules ?? [])
          .any((rule) => rule is RuleIncrement),
      requiresMetadata: () => (rulesKey.currentState?.rules ?? [])
          .any((rule) => rule.requiresMetadata),
      clearRules: () {
        rulesKey.currentState?.clearRule();
      },
    );

    final rulesPage = _lockWhileRenaming(
      RulesPage(
        key: rulesKey,
        onRuleChanged: () {
          filesKey.currentState?.update();
        },
      ),
    );

    return Scaffold(
      bottomNavigationBar: _lockWhileRenaming(
        HomeToolBar(
          hapticFeedbackCallback: (value) => Shared.hapticFeedback = value,
          hapticFeedbackValue: () => Shared.hapticFeedback,
          showThumbnailsCallback: (value) => setState(() {
            Shared.showThumbnails = value;
          }),
          showThumbnailsValue: () => Shared.showThumbnails,
          onlySelectedCallback: (value) => Shared.onlySelected = value,
          onlySelectedValue: () => Shared.onlySelected,
          removeRenamedCallback: (value) => Shared.removeRenamed = value,
          removeRenamedValue: () => Shared.removeRenamed,
          removeRulesCallback: (value) => Shared.removeRules = value,
          removeRulesValue: () => Shared.removeRules,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _renaming
            ? null
            : () {
                filesKey.currentState?.renameFiles(
                  remove: Shared.removeRenamed,
                  onlySelected: Shared.onlySelected,
                );
              },
        tooltip: L10n.current.rename,
        child: _renaming
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.play_arrow_rounded),
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

  Widget _lockWhileRenaming(Widget child) => ExcludeFocus(
        excluding: _renaming,
        child: AbsorbPointer(absorbing: _renaming, child: child),
      );
}

class HomeToolBar extends StatefulWidget {
  const HomeToolBar({
    super.key,
    required this.hapticFeedbackCallback,
    required this.hapticFeedbackValue,
    required this.showThumbnailsCallback,
    required this.showThumbnailsValue,
    required this.onlySelectedCallback,
    required this.onlySelectedValue,
    required this.removeRenamedCallback,
    required this.removeRenamedValue,
    required this.removeRulesCallback,
    required this.removeRulesValue,
  });

  final void Function(bool) hapticFeedbackCallback;
  final bool Function() hapticFeedbackValue;

  final void Function(bool) showThumbnailsCallback;
  final bool Function() showThumbnailsValue;

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
  bool expanded = false;
  static const _dire = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Responsive(
        mobile: ListView(
          scrollDirection: _dire,
          children: [
            ..._iconButtons(),
            _expandIndicator(),
            if (expanded) ..._chips(),
          ],
        ),
        desktop: ListView(
          scrollDirection: _dire,
          children: [
            ..._iconButtons(),
            ..._chips(),
          ],
        ),
      ),
    );
  }

  List<IconButton> _iconButtons() => [
        IconButton(
          tooltip: L10n.current.showThumbnails,
          isSelected: widget.showThumbnailsValue(),
          icon: const Icon(Icons.image_outlined),
          selectedIcon: const Icon(Icons.image),
          onPressed: () => setState(() {
            widget.showThumbnailsCallback(!widget.showThumbnailsValue());
          }),
        ),
        IconButton(
          tooltip: L10n.current.appInfo,
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
                'assets/desktop.png',
                width: 48,
              ),
              applicationLegalese:
                  'Copyright (C) 2023 Sun Jiao. GNU GENERAL PUBLIC LICENSE Version 3.',
              children: [
                Text(L10n.current.aboutContent),
                InkWell(
                  child: const Text(
                    'Localized text is generated using machine translation, if you find any errors please help us fix it.',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                        'https://github.com/sun-jiao/renamer/issues/new',
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        IconButton(
          tooltip: L10n.current.rating,
          icon: const Icon(Icons.star_rate_rounded),
          onPressed: ratingMyApp,
        ),
        IconButton(
          tooltip: L10n.current.viewLog,
          icon: const Icon(Icons.history_rounded),
          onPressed: () async {
            final logs = await Logger().readLogs();
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => CustomDialog(
                title: Text(L10n.current.viewLog),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SelectionArea(
                    child: SingleChildScrollView(
                      child: Text(
                        logs.isEmpty ? L10n.current.logEmpty : logs,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).deleteButtonTooltip,
                    onPressed: () async {
                      await Logger().clearLogs();
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(L10n.current.ok),
                  ),
                ],
              ),
            );
          },
        ),
        IconButton(
          tooltip: L10n.current.sourceCode,
          icon: const Icon(Icons.code_rounded),
          onPressed: gotoGithub,
        ),
      ];

  IconButton _expandIndicator() => IconButton(
        tooltip: expanded
            ? L10n.current.collapseOptions
            : L10n.current.expandOptions,
        onPressed: () {
          setState(() {
            expanded = !expanded;
          });
        },
        icon: Icon(
          expanded
              ? Icons.arrow_back_ios_new_rounded
              : Icons.arrow_forward_ios_rounded,
          size: 20,
        ),
      );

  List<Widget> _chips() => [
        box,
        FilterChip(
          label: Text(L10n.current.onlySelected),
          onSelected: (value) => setState(() {
            widget.onlySelectedCallback.call(value);
          }),
          selected: widget.onlySelectedValue.call(),
        ),
        box,
        FilterChip(
          label: Text(L10n.current.removeRenamed),
          onSelected: (value) => setState(() {
            widget.removeRenamedCallback.call(value);
          }),
          selected: widget.removeRenamedValue.call(),
        ),
        box,
        FilterChip(
          label: Text(L10n.current.removeRules),
          onSelected: (value) => setState(() {
            widget.removeRulesCallback.call(value);
          }),
          selected: widget.removeRulesValue.call(),
        ),
        if (AppHaptics.supported) ...[
          box,
          FilterChip(
            label: Text(L10n.current.hapticFeedback),
            selected: widget.hapticFeedbackValue(),
            onSelected: (value) => setState(() {
              widget.hapticFeedbackCallback(value);
            }),
          ),
        ],
      ];

  void ratingMyApp() => showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: Text(L10n.current.ratingTitle),
          content: Text(L10n.current.ratingContent),
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
                child: Text(L10n.current.ratingStore),
              ),
            TextButton(
              onPressed: gotoGithub,
              child: Text(L10n.current.ratingGithub),
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
