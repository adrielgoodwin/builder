
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
  String deCapitalize() {
    return "${this[0].toLowerCase()}${this.substring(1).toLowerCase()}";
  }
}

