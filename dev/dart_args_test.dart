import 'package:args/args.dart';
import 'package:flutter/cupertino.dart';

void main([List<String> arguments = const []]) async {
  var parser = ArgParser();
  parser.addFlag('hekl', abbr: 'h');

  arguments.indexWhere((element) => element.startsWith('-'));

  final results = parser.parse(arguments);

  debugPrint(results.options.toList().toString());
  debugPrint(results.arguments.toString());
  debugPrint(results.rest.toString());

  debugPrint(arguments.toString());
}