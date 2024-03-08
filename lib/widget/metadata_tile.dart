import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../tools/ex_text_editing_controller.dart';
import '../dialogs/metadata_dialog.dart';
import '../l10n/l10n.dart';
import 'checkbox_tile.dart';

class MetadataTile extends StatefulWidget {
  const MetadataTile({super.key, required this.textController, required this.withMetadata});

  final TextEditingController textController;
  final ValueNotifier<bool> withMetadata;
  @override
  State<MetadataTile> createState() => _MetadataTileState();
}

class _MetadataTileState extends State<MetadataTile> {
  final Map<CustomSemanticsAction, VoidCallback> _semanticsActions = <CustomSemanticsAction, VoidCallback>{};
  
  @override
  void initState() {
    _semanticsActions[CustomSemanticsAction(label: L10n.current.semanticsOpenMetadataDialog)] = _showDialog;
    super.initState();
  }

  void _showDialog() => showMetadataDialog(context, (tag) {
    widget.textController.insertTag(tag, context);
    setState(() {
      widget.withMetadata.value = true;
    });
  });

  void _onChanged(bool? value) => setState(() {
    widget.withMetadata.value = value ?? widget.withMetadata.value;
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      customSemanticsActions: _semanticsActions,
      child: CheckboxTile(
        title: Text(
          L10n.current.metadataTags,
          softWrap: false,
        ),
        value: widget.withMetadata.value,
        onChanged: _onChanged,
        trailing: Semantics(
          label: L10n.current.semanticsMultipleActionsHint,
          child: IconButton(
            onPressed: _showDialog,
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ),
      ),
    );
  }
}
