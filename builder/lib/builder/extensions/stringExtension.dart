extension StringExtension on String {
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

String formatClassName(String value) {
  List<int> spaces = indexesOfAll(value, " ");
  String formattedClassName = "";
  for (var i = 0; i < spaces.length; i++) {
    String segment;
    // check to see if we are at beginning
    if (i == 0) {
      segment = [value.substring(0, spaces[0]), value.substring(spaces[0], spaces[0] + 1).toUpperCase()].join("");
    } else {
      segment = [value.substring(spaces[i - 1], spaces[i]), value.substring(spaces[i], spaces[i] + 1).toUpperCase()].join("");
    }
    formattedClassName += segment;
  }
  return formattedClassName;
}

List<int> indexesOfAll(String string, String thing) {
  List<int> indexes = [];
  var moreThings = true;
  var index = 0;
  var newIndex = 0;
  while (moreThings) {
    newIndex = string.indexOf(thing);
    if (newIndex != -1) {
      indexes = [...indexes, newIndex + index];
      newIndex = string.substring(index + 1).indexOf(" ");
    } else {
      moreThings = false;
    }
  }
  return indexes;
}