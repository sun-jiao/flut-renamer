part of 'rule.dart';

abstract class Rule {
  String newName(String oldName) {
    throw UnimplementedError();
  }

  @override
  String toString();
}

(String, String) splitFileName(String oldName, bool ignoreExtension) {
  String newName = oldName;
  String extension = '';

  if (ignoreExtension) {
    final lastIndex = oldName.lastIndexOf('.');

    extension = oldName.substring(lastIndex);
    newName = oldName.substring(0, lastIndex);
  }

  return (newName, extension);
}
