part of 'rule.dart';

class RuleTransliterate implements Rule {
  RuleTransliterate(
    this.type, {
    this.langCode,
  });

  final Transliterate type;
  final String? langCode;

  @override
  String newName(String oldName, {FileMetadata? metadata}) {
    String newName, extension;
    (newName, extension) = splitFileName(oldName, true);

    switch (type) {
      case Transliterate.upper:
        return newName.toUpperCase() + extension;
      case Transliterate.lower:
        return newName.toLowerCase() + extension;
      case Transliterate.traditional:
        return ChineseHelper.convertToTraditionalChinese(newName) + extension;
      case Transliterate.simplified:
        return ChineseHelper.convertToSimplifiedChinese(newName) + extension;
      case Transliterate.pinyin:
        return PinyinHelper.getPinyin(
              newName,
              separator: '_',
              format: PinyinFormat.WITH_TONE_MARK,
            ) +
            extension;
      case Transliterate.cyrillic2Latin:
        return cyrtranslit.cyr2Lat(newName, langCode: langCode!) + extension;
      case Transliterate.latin2Cyrillic:
        return cyrtranslit.lat2Cyr(newName, langCode: langCode!) + extension;
      default:
        return oldName;
    }
  }

  static const langCodeMap = {
    'bg': 'Bulgarian',
    'me': 'Montenegrin',
    'mk': 'Macedonian',
    'mn': 'Mongolian',
    'ru': 'Russian',
    'sr': 'Serbian',
    'tj': 'Tajik',
    'ua': 'Ukrainian',
  };

  @override
  String toString() {
    if ([Transliterate.cyrillic2Latin, Transliterate.latin2Cyrillic].contains(type)) {
      return L10n.current.transliterateToStringCyrillic(langCodeMap[langCode]!, type.toString());
    } else {
      return L10n.current.transliterateToString(type.toString());
    }
  }
}
