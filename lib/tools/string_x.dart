extension StringX on String {
  String replaceLastMapped(Pattern from, String Function(Match match) replace) {
    int lastIndex = lastIndexOf(from);
    if (lastIndex != -1) {
      return replaceFirstMapped(from, replace, lastIndex);
    }

    return this;
  }
}
