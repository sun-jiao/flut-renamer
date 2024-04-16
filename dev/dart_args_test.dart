import 'package:args/args.dart';

void main([List<String> arguments = const []]) async {
  var parser = ArgParser();
  parser.addFlag('hekl', abbr: 'h');

  arguments.indexWhere((element) => element.startsWith('-'));

  final results = parser.parse(arguments);

  print(results.options.toList());
  print(results.arguments);
  print(results.rest);

  print(arguments);
}