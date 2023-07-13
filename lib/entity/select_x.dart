import 'package:cross_file/cross_file.dart';

extension SelectX on XFile {
  static final List<String> _selection = [];

  bool get selected => _selection.contains(path);

  set selected(bool val) =>
      val ? _selection.add(path) : _selection.remove(path);

  static void clear() => _selection.clear();
}
