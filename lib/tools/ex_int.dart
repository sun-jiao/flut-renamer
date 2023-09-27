extension ExInt on int {
  String toOrdinal() {
    if (this % 10 == 1 && this % 100 != 11) {
      return '$this' 'st';
    } else if (this % 10 == 2 && this % 100 != 12) {
      return '$this' 'nd';
    } else if (this % 10 == 3 && this % 100 != 13) {
      return '$this' 'rd';
    } else {
      return '$this' 'th';
    }
  }
}
