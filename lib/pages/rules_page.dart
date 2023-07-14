import 'package:flutter/material.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  List<String> _rules = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(),
          Expanded(
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = _rules.removeAt(oldIndex);
                  _rules.insert(newIndex, item);
                });
              },
              buildDefaultDragHandles: false,
              itemBuilder: (context, index) {
                final item = _rules[index];
                return ListTile(
                  title: Text(item),
                  key: ValueKey(item),
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                );
              },
              itemCount: _rules.length,
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
