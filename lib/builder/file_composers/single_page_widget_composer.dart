

String makeShowFunction(List<String> requiredClassData, String pageName) {
  var requiredParams = requiredClassData.map((e) => " required $e ${e.paramify()}").toList().join(", ");
  var requiredArgs = requiredClassData.map((e) => "'${e.paramify()}': ${e.paramify()},").toList().join(", \n");
  var showFunc = '''  static Future<void> show(
      {required BuildContext context, $requiredParams}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.$pageName,
      arguments: {
         $requiredArgs
       },
     );
   }
''';
  return showFunc;
}

// class come {
//   static Future<void> show(
//       {required BuildContext context, required Job job, Entry? entry}) async {
//     await Navigator.of(context, rootNavigator: true).pushNamed(
//       AppRoutes.entryPage,
//       arguments: {
//         'job': job,
//         'entry': entry,
//       },
//     );
//   }
// }


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