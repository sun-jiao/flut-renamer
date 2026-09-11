part of 'rule.dart';

abstract interface class Rule {
  FutureOr<String> newName(String oldName, {FileMetadata? metadata});

  /// Whether evaluating this rule needs file, EXIF, or audio metadata.
  ///
  /// Rules that merely have metadata mode enabled but contain no metadata tag
  /// do not need to cause an expensive metadata read.
  bool get requiresMetadata;

  void openDialog(BuildContext context, Function(Rule rule) onSave);

  Map<String, dynamic> toMap();

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
