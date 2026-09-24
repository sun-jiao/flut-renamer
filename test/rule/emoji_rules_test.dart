import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/entity/transliterate.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  const characters = [
    '😀',
    '👍🏽',
    '👨‍👩‍👧‍👦',
    '🇨🇳',
    '❤️',
    '1️⃣',
    'e\u0301',
  ];
  for (final character in characters) {
    group('complete character $character', () {
      test('ordinary and number insertion use identical positions', () async {
        for (final fromEnd in [false, true]) {
          final name = 'a${character}b.txt';
          final position = fromEnd ? 1 : 2;
          expect(
            await RuleInsert('_', position, fromEnd, false, true).newName(name),
            'a${character}_b.txt',
          );
          expect(
            await RuleIncrement(
              '',
              1,
              1,
              true,
              true,
              mode: IncrementMode.insert,
              insertIndex: position,
              toEnd: fromEnd,
              suffix: '_',
            ).newName(name),
            'a${character}1_b.txt',
          );
        }
      });
      test('truncate keeps and removes whole characters in both directions',
          () {
        final name = 'a${character}b.txt';
        expect(
          RuleTruncate(1, 2, false, false, true, true).newName(name),
          '$character.txt',
        );
        expect(
          RuleTruncate(1, 2, true, true, true, true).newName(name),
          '$character.txt',
        );
        expect(
          RuleTruncate(2, 1, false, false, true, false).newName(name),
          'ab.txt',
        );
        expect(RuleTruncate(99, 0, true, true, true, true).newName(name), name);
      });
      test('empty delimiter rearranges characters, text delimiter keeps them',
          () {
        expect(
          RuleRearrange('', [3, 2, 1], true).newName('a${character}b.txt'),
          'b${character}a.txt',
        );
        expect(
          RuleRearrange('-', [2, 1], true).newName('a-$character.txt'),
          '$character-a.txt',
        );
        expect(
          RuleRearrange(character, [2, 1], true).newName('a${character}b.txt'),
          'b${character}a.txt',
        );
      });
      test('replace and remove respect limits and full emoji targets',
          () async {
        final name = '$character-$character-$character.txt';
        for (final regex in [false, true]) {
          expect(
            await RuleReplace(character, 'X', 1, false, true, regex, true)
                .newName(name),
            'X-$character-$character.txt',
          );
          expect(
            await RuleReplace(character, 'X', -1, false, true, regex, true)
                .newName(name),
            '$character-$character-X.txt',
          );
          expect(
            await RuleRemove(character, 0, true, regex, true).newName(name),
            '--.txt',
          );
        }
      });
      test('replacement-mode numbering preserves emoji affixes and extensions',
          () async {
        expect(
          await RuleIncrement(character, 1, 1, true, true, suffix: character)
              .newName('old.$character'),
          '${character}1$character.$character',
        );
      });
    });
  }

  test('literal and regex matches cannot remove part of a grapheme', () async {
    for (final pair in [
      ['👍🏽', '👍'],
      ['👨‍👩‍👧‍👦', '👩'],
      ['🇨🇳', '🇨'],
      ['❤️', '❤'],
      ['1️⃣', '1'],
      ['e\u0301', 'e'],
      ['😀', '\uD83D'],
    ]) {
      final name = '${pair[0]}_${pair[1]}.txt';
      for (final regex in [false, true]) {
        for (final limit in [0, 1, -1]) {
          expect(
            await RuleReplace(pair[1], 'X', limit, false, true, regex, true)
                .newName(name),
            '${pair[0]}_X.txt',
          );
          expect(
            await RuleRemove(pair[1], limit, true, regex, true).newName(name),
            '${pair[0]}_.txt',
          );
        }
      }
      expect(
        RuleRearrange(pair[1], [1], true).newName('${pair[0]}.txt'),
        '${pair[0]}.txt',
      );
    }
  });

  test('regex dot handles surrogate pairs and skips partial composite matches',
      () async {
    expect(
      await RuleReplace('.', 'X', 0, false, true, true, true)
          .newName('😀👨‍👩‍👧‍👦a.txt'),
      'X👨‍👩‍👧‍👦X.txt',
    );
    expect(
      await RuleReplace('.*', 'X', 1, false, true, true, true)
          .newName('😀👨‍👩‍👧‍👦a.txt'),
      'X.txt',
    );
    expect(
      await RuleReplace('(?=.)', '_', 0, false, true, true, true)
          .newName('👍🏽😀.txt'),
      '_👍🏽_😀.txt',
    );
    expect(
      await RuleReplace('(😀)(👍🏽)', r'\2\1', 0, false, true, true, true)
          .newName('😀👍🏽.txt'),
      '👍🏽😀.txt',
    );
  });

  test('extension participation and empty ranges remain consistent', () async {
    expect(
      await RuleInsert('_', 1, true, false, false).newName('a.😀'),
      'a._😀',
    );
    expect(RuleTruncate(1, 0, true, true, false, true).newName('a.😀'), '😀');
    expect(await RuleRemove('😀', 0, true, false, false).newName('a.😀'), 'a.');
    expect(RuleRearrange('', [3, 2, 1], false).newName('a.😀'), '😀.a');
    expect(await RuleInsert('😀', 99, false, false, true).newName(''), '😀');
    expect(RuleTruncate(9, 2, false, false, false, true).newName(''), '');
    expect(RuleRearrange('', [1], true).newName(''), '');
  });

  for (final type in Transliterate.values) {
    test('transliteration ${type.name} preserves emoji sequences', () {
      const emoji = '😀👍🏽👨‍👩‍👧‍👦🇨🇳❤️1️⃣';
      final rule = RuleTransliterate(type);
      expect(rule.newName('$emoji.txt'), '$emoji.txt');
      expect(rule.newName('${emoji}_.txt'), '${emoji}_.txt');
      final mixed = rule.newName('文${emoji}Ab.txt');
      expect(mixed, contains(emoji));
      expect(mixed, endsWith('.txt'));
    });
  }
}
