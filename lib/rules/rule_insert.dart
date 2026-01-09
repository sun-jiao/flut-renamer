part of 'rule.dart';

class RuleInsert implements Rule {
  RuleInsert(
    this.insert,
    this.insertIndex,
    this.toEnd,
    this.withMetadata,
    this.ignoreExtension,
  );

  final String insert; // string to be inserted
  final int insertIndex; // insert before character at index
  final bool toEnd; // true: count from start; false: from end.
  final bool withMetadata; // true: replace metadata tag with metadata
  final bool ignoreExtension;

  @override
  Future<String> newName(String oldName, {FileMetadata? metadata}) async {
    if (withMetadata && metadata == null) {
      throw ArgumentError(
        L10n.current.metadataParserNotProvided,
      );
    }

    String newName, extension;
    (newName, extension) = splitFileName(oldName, ignoreExtension);

    String insert = this.insert;

    // 检查并替换特殊的随机字符串标记，支持在任何位置出现
    final RegExp randomStringRegex = RegExp(r'\{RandomString(?::(\d+))?\}');
    if (randomStringRegex.hasMatch(insert)) {
      insert = insert.replaceAllMapped(randomStringRegex, (match) {
        int length = 8;
        if (match.group(1) != null) {
          length = int.tryParse(match.group(1)!) ?? 8;
          // 确保长度在合理范围内
          length = length.clamp(1, 32);
        }
        // 生成不包含特殊字符的随机字符串
        String uuid = Uuid().v4().replaceAll('-', '');
        return uuid.substring(0, length);
      });
    }

    if (withMetadata) {
      await metadata!.init();
      insert = metadata.parse(insert);
    }

    int index = insertIndex;

    if (toEnd) {
      index = newName.length - index;
    }

    if (index < 0) {
      index = 0;
    } else if (index > newName.length) {
      index = newName.length;
    }

    newName = newName.substring(0, index) + insert + newName.substring(index);

    return newName + extension;
  }

  @override
  String toString() {
    return L10n.current.insertToString(toEnd.toString(), 'o${insertIndex % 10}', insert, insertIndex);
  }

  @override
  void openDialog(BuildContext context, Function(Rule rule) onSave) => showInsertDialog(context, onSave, this);
}
