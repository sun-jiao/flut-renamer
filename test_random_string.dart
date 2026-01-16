
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'lib/rules/rule_insert.dart';
import 'lib/tools/file_metadata.dart';

void main() {
  test('Test RandomString replacement', () async {
    // 创建一个简单的测试用例
    String oldName = '1234.jpg';
    
    // 测试默认长度
    RuleInsert rule1 = RuleInsert('{RandomString}', 0, false, false, true);
    String result1 = await rule1.newName(oldName);
    print('Test 1 (default length): $result1');
    expect(result1, isNot(contains('{RandomString}')));
    expect(result1.length, oldName.length + 7); // 8个字符替换了 {RandomString} (14个字符)
    
    // 测试自定义长度
    RuleInsert rule2 = RuleInsert('{RandomString:10}', 0, false, false, true);
    String result2 = await rule2.newName(oldName);
    print('Test 2 (length 10): $result2');
    expect(result2, isNot(contains('{RandomString:10}')));
    expect(result2.length, oldName.length + 5); // 10个字符替换了 {RandomString:10} (15个字符)
    
    // 测试直接使用Uuid生成
    String uuidTest = Uuid().v4().substring(0, 8);
    print('Uuid test: $uuidTest');
    expect(uuidTest.length, 8);
    
    print('All tests passed!');
  });
}
