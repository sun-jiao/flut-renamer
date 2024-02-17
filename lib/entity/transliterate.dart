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
}
