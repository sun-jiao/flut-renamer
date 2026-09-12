import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/transliterate.dart';
import 'package:flut_renamer/l10n/l10n.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  setUpAll(() => L10n.load(const Locale('en')));

  test('changes case without changing the extension', () {
    expect(
      RuleTransliterate(Transliterate.upper).newName('Summer.Photo.JpG'),
      'SUMMER.PHOTO.JpG',
    );
    expect(
      RuleTransliterate(Transliterate.lower).newName('Summer.Photo.JpG'),
      'summer.photo.JpG',
    );
  });

  test('converts Chinese and produces pinyin', () {
    expect(
      RuleTransliterate(Transliterate.traditional).newName('汉语.jpg'),
      '漢語.jpg',
    );
    expect(
      RuleTransliterate(Transliterate.simplified).newName('漢語.jpg'),
      '汉语.jpg',
    );
    expect(
      RuleTransliterate(Transliterate.pinyin).newName('中文.jpg'),
      contains('zhōng_wén.jpg'),
    );
  });

  test('transliterates Cyrillic using the selected language and round-trips',
      () {
    final latin = RuleTransliterate(
      Transliterate.cyrillic2Latin,
      langCode: 'ru',
    ).newName('Привет.txt');
    expect(latin, isNot('Привет.txt'));
    expect(latin, endsWith('.txt'));

    final cyrillic = RuleTransliterate(
      Transliterate.latin2Cyrillic,
      langCode: 'ru',
    ).newName('Privet.txt');
    expect(cyrillic, isNot('Privet.txt'));
    expect(cyrillic, endsWith('.txt'));
  });

  test('serializes and restores its type and language', () {
    final rule =
        RuleTransliterate(Transliterate.latin2Cyrillic, langCode: 'sr');
    final restored = RuleFactory.fromMap(rule.toMap()) as RuleTransliterate;

    expect(restored.type, Transliterate.latin2Cyrillic);
    expect(restored.langCode, 'sr');
  });
}
