import '../l10n/l10n.dart';

enum Transliterate {
  upper(0),
  lower(1),
  traditional(2),
  simplified(3),
  pinyin(4),
  cyrillic2Latin(5),
  latin2Cyrillic(6);

  const Transliterate(this.value);

  final int value;

  @override
  String toString() {
    switch (this) {
      case Transliterate.upper:
        return L10n.current.transliterateUpper;
      case Transliterate.lower:
        return L10n.current.transliterateLower;
      case Transliterate.traditional:
        return L10n.current.transliterateTraditional;
      case Transliterate.simplified:
        return L10n.current.transliterateSimplified;
      case Transliterate.pinyin:
        return L10n.current.transliteratePinyin;
      case Transliterate.cyrillic2Latin:
        return L10n.current.transliterateCyrillic2Latin;
      case Transliterate.latin2Cyrillic:
        return L10n.current.transliterateLatin2Cyrillic;
      default:
        return '?';
    }
  }
}
