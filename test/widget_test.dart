// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'rule/replace.dart' as replace_test;
import 'rule/insert.dart' as insert_test;
import 'rule/rearrange.dart' as rearrange_test;

void main() {
  group('rule replace', replace_test.main);
  group('rule insert', insert_test.main);
  group('rule rearrange', rearrange_test.main);
}
