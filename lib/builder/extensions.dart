
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
  String deCapitalize() {
    return "${this[0].toLowerCase()}${this.substring(1).toLowerCase()}";
  }
  // from underscores to proper camelcase
  String classify() {
    var string = "${this[0].toUpperCase()}${this.substring(1)}";
    for (;;) {
      int index = string.indexOf('_');
      if (index != -1) {
        var firstPart = string.substring(0, index);
        string = string.replaceFirst("_", "");
        var secondPart = string.substring(index);
        secondPart = "${secondPart[0].toUpperCase()}${secondPart.substring(1)}";
        string = "$firstPart$secondPart";
      } else {
        break;
      }
    }
    return string;
  }

  String paramify() {
    if (isNotEmpty) {
      var string = "${this[0].toLowerCase()}${this.substring(1)}";
      for (;;) {
        int index = string.indexOf('_');
        if (index != -1) {
          var firstPart = string.substring(0, index);
          string = string.replaceFirst("_", "");
          var secondPart = string.substring(index);
          secondPart = "${secondPart[0].toUpperCase()}${secondPart.substring(1)}";
          string = "$firstPart$secondPart";
        } else {
          break;
        }
      }
      return string;
    }
    return "";
  }
}

