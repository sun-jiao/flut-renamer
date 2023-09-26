import 'dart:io';

extension ExFile on File {
  // get file name
  String get name => path.substring(path.lastIndexOf('/') + 1);

  // get the directory
  String get directory => path.substring(0, path.lastIndexOf('/'));
}
