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
        return 'Latin characters to upper case';
      case Transliterate.lower:
        return 'Latin characters to lower case';
      case Transliterate.traditional:
        return 'Chinese characters to traditional Chinese';
      case Transliterate.simplified:
        return 'Chinese characters to simplified Chinese';
      case Transliterate.pinyin:
        return 'Chinese characters to pinyin';
      case Transliterate.cyrillic2Latin:
        return 'Cyrillic characters to Latin';
      case Transliterate.latin2Cyrillic:
        return 'Latin characters to Cyrillic';
      default:
        return '?';
    }
  }
}
