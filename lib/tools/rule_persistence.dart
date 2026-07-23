import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import '../rules/rule.dart';

class RulePersistence {
  static Future<File> _getTempFile() async {
    final directory = await getTemporaryDirectory();
    return File('${directory.path}/temp_rules.yaml');
  }

  static Future<void> saveRules(List<Rule> rules, {File? targetFile}) async {
    final file = targetFile ?? await _getTempFile();
    final List<Map<String, dynamic>> ruleMaps = rules.map((r) => r.toMap()).toList();
    final yamlWriter = YamlWriter();
    final yamlString = yamlWriter.write(ruleMaps);
    await file.writeAsString(yamlString, encoding: utf8);
  }

  static Future<List<Rule>> loadRules({File? sourceFile}) async {
    final file = sourceFile ?? await _getTempFile();
    if (!await file.exists()) return [];

    final content = await file.readAsString(encoding: utf8);
    if (content.isEmpty) return [];

    final yamlData = loadYaml(content);
    if (yamlData is! YamlList) return [];

    final List<Rule> rules = [];
    for (final item in yamlData) {
      if (item is YamlMap) {
        final rule = RuleFactory.fromMap(item);
        if (rule != null) {
          rules.add(rule);
        }
      }
    }
    return rules;
  }
}
