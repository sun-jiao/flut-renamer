import 'dart:io';

import 'package:flutter/material.dart';
import 'package:renamer/tools/responsive.dart';

import '../entity/constants.dart';
import '../entity/sharedpref.dart';
import '../rules/rule.dart';
import '../tools/file_metadata.dart';
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
                flex: 3,
                child: filesPage,
              ),
              Expanded(
                flex: 2,
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
  bool expanded = !Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: Platform.isAndroid ? 64 : null,
      padding: const EdgeInsets.all(8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 64),
        children: [
          IconButton(
            tooltip: 'App info',
            icon: const Icon(Icons.info_rounded),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => Placeholder())),
          ),
          IconButton(
            tooltip: 'Rating in Play Store',
            icon: const Icon(Icons.star_rate_rounded),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => Placeholder())),
          ),
          IconButton(
            tooltip: 'Source code',
            icon: const Icon(Icons.code_rounded),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => Placeholder())),
          ),
          if (Platform.isAndroid)
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
}
