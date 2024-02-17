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
    switch (type) {
      case Transliterate.upper:
        return 'Transliterate: convert Latin characters to upper case.';
      case Transliterate.lower:
        return 'Transliterate: convert Latin characters to lower case.';
      case Transliterate.traditional:
        return 'Transliterate: convert Chinese characters to traditional Chinese.';
      case Transliterate.simplified:
        return 'Transliterate: convert Chinese characters to simplified Chinese.';
      case Transliterate.pinyin:
        return 'Transliterate: convert Chinese characters to pinyin.';
      case Transliterate.cyrillic2Latin:
        return 'Transliterate: convert ${langCodeMap[langCode]} from cyrillic characters to latin.';
      case Transliterate.latin2Cyrillic:
        return 'Transliterate: convert ${langCodeMap[langCode]} from latin characters to cyrillic.';
      default:
        return 'Transliterate: ?';
    }
  }
}
