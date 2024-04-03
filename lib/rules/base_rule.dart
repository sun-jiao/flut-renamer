part of 'rule.dart';

abstract interface class Rule {
  FutureOr<String> newName(String oldName, {FileMetadata? metadata});

  void openDialog(BuildContext context, Function(Rule rule) onSave);

  DialogConfig get dialogConfig;

  @override
  String toString();
}

(String, String) splitFileName(String oldName, bool ignoreExtension) {
  String newName = oldName;
  String extension = '';

  if (ignoreExtension) {
    final lastIndex = oldName.lastIndexOf('.');

    if (lastIndex > 0) {
      extension = oldName.substring(lastIndex);
      newName = oldName.substring(0, lastIndex);
    }
  }

  return (newName, extension);
}

class DialogConfig {
  DialogConfig(this.title, this.description, this.fields);

  final String title;
  final String description;
  final List<DialogField> fields;
}

class DialogField<T> extends ValueNotifier<T> {
  DialogField(
    super._value, {
    this.description = "",
    Map<String, dynamic>? appendixData,
  }) : appendixData = appendixData ?? {};

  final String description;
  final Map<String, dynamic> appendixData;
}

class DirectionalInt {
  DirectionalInt(this.value, bool direction):direction = ValueNotifier(direction);

  int value;
  ValueNotifier<bool> direction;
}