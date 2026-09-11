// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'pages/files_page_test.dart' as files_page_test;
import 'pages/home_tool_bar_test.dart' as home_tool_bar_test;
import 'rule/replace.dart' as replace_test;
import 'rule/insert.dart' as insert_test;
import 'rule/increment.dart' as increment_test;
import 'rule/rearrange.dart' as rearrange_test;
import 'rule/rule_serialization_test.dart' as rule_serialization_test;
import 'rule/random_string_test.dart' as random_string_test;
import 'tools/rename_test.dart' as rename_test;
import 'tools/rename_transaction_test.dart' as rename_transaction_test;
import 'tools/logger_test.dart' as logger_test;
import 'tools/file_metadata_test.dart' as file_metadata_test;
import 'tools/file_sort_test.dart' as file_sort_test;
import 'widget/custom_drop_test.dart' as custom_drop_test;

void main() {
  group('rule replace', replace_test.main);
  group('rule insert', insert_test.main);
  group('rule increment', increment_test.main);
  group('rule rearrange', rearrange_test.main);
  group('rule replace serialization', rule_serialization_test.main);
  group('rename test', rename_test.main);
  group('rename transaction test', rename_transaction_test.main);
  group('random string test', random_string_test.main);
  group('file metadata test', file_metadata_test.main);
  group('file sort test', file_sort_test.main);
  group('logger test', logger_test.main);
  group('custom drop test', custom_drop_test.main);
  group('files page test', files_page_test.main);
  group('home tool bar test', home_tool_bar_test.main);
}
