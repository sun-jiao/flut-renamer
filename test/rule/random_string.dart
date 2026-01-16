library renamer.test.rule.random_string;

import 'package:flutter_test/flutter_test.dart';
import 'package:flut_renamer/rules/rule.dart';

void main() {
  test('test random string replacement with default length', () async {
    String fileName = "1234.jpg";
    
    RuleInsert rule = RuleInsert('{RandomString}', 0, false, false, true);
    String newFileName = await rule.newName(fileName);
    
    print('Test default length: $newFileName');
    expect(newFileName, isNot(contains('{RandomString}')));
    
    // 检查结果是否以8个字符开头，后面跟着1234.jpg
    expect(newFileName.endsWith("1234.jpg"), isTrue);
    // 检查随机字符串部分是否是8个字符
    int prefixLength = newFileName.length - "1234.jpg".length;
    expect(prefixLength, equals(8));
    // 检查前缀是否只包含字母和数字
    String prefix = newFileName.substring(0, prefixLength);
    expect(prefix, matches(RegExp(r'^[a-f0-9]{8}$')));
  });

  test('test random string replacement with custom length', () async {
    String fileName = "1234.jpg";
    
    RuleInsert rule = RuleInsert('{RandomString:10}', 0, false, false, true);
    String newFileName = await rule.newName(fileName);
    
    print('Test custom length (10): $newFileName');
    expect(newFileName, isNot(contains('{RandomString:10}')));
    
    // 检查结果是否以10个字符开头，后面跟着1234.jpg
    expect(newFileName.endsWith("1234.jpg"), isTrue);
    int prefixLength = newFileName.length - "1234.jpg".length;
    expect(prefixLength, equals(10));
    String prefix = newFileName.substring(0, prefixLength);
    expect(prefix, matches(RegExp(r'^[a-f0-9]{10}$')));
  });

  test('test random string replacement with different length', () async {
    String fileName = "test.txt";
    
    // 测试长度为5
    RuleInsert rule1 = RuleInsert('{RandomString:5}', 0, false, false, true);
    String newFileName1 = await rule1.newName(fileName);
    print('Test length 5: $newFileName1');
    expect(newFileName1, isNot(contains('{RandomString:5}')));
    expect(newFileName1.endsWith("test.txt"), isTrue);
    int prefixLength1 = newFileName1.length - "test.txt".length;
    expect(prefixLength1, equals(5));
    String prefix1 = newFileName1.substring(0, prefixLength1);
    expect(prefix1, matches(RegExp(r'^[a-f0-9]{5}$')));
    
    // 测试长度为15
    RuleInsert rule2 = RuleInsert('{RandomString:15}', 0, false, false, true);
    String newFileName2 = await rule2.newName(fileName);
    print('Test length 15: $newFileName2');
    expect(newFileName2, isNot(contains('{RandomString:15}')));
    expect(newFileName2.endsWith("test.txt"), isTrue);
    int prefixLength2 = newFileName2.length - "test.txt".length;
    expect(prefixLength2, equals(15));
    String prefix2 = newFileName2.substring(0, prefixLength2);
    expect(prefix2, matches(RegExp(r'^[a-f0-9]{15}$')));
  });

  test('test random string replacement in the middle', () async {
    String fileName = "abcdefgh.txt";
    
    RuleInsert rule = RuleInsert('{RandomString:6}', 4, false, false, true);
    String newFileName = await rule.newName(fileName);
    
    print('Test insert in middle: $newFileName');
    expect(newFileName, isNot(contains('{RandomString:6}')));
    
    // 检查结果是否是 "abcd" + 6个随机字符 + "efgh.txt"
    expect(newFileName.startsWith("abcd"), isTrue);
    expect(newFileName.endsWith("efgh.txt"), isTrue);
    
    int middleLength = newFileName.length - "abcd".length - "efgh.txt".length;
    expect(middleLength, equals(6));
    
    String middle = newFileName.substring("abcd".length, "abcd".length + middleLength);
    expect(middle, matches(RegExp(r'^[a-f0-9]{6}$')));
  });
}
