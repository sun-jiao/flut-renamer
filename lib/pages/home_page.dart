import 'package:flutter/material.dart';

import 'rules_page.dart';
import 'files_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: FilesPage(),
          ),
          Expanded(
            flex: 2,
            child: RulesPage(),
          ),
        ],
      ),
    );
  }
}
