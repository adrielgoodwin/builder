import '../models/page_data.dart';

/// todo later - Add database and sign in and all that

class AppRouterComposer {

  late List<PageData> pageDatas;
  List<String> imports = [];
  List<String> head = [];
  List<String> routes = [];
  List<String> appRouterHead = [];
  List<String> appRouters = [];
  List<String> appRoutersTail = [];
  List<String> end = [];

  String composeFromPageDatas(List<PageData> pageDatas) {
    this.pageDatas = pageDatas;
    go();
    return makeFile();
  }

  String makeFile() {
    return [...imports, ...head, ...routes, ...appRouterHead, ...appRouters, ...appRoutersTail, ...end].join("\n");
  }

  void go() {
    generateImports();
    generateHead();
    generateRoutes();
    generateAppRouterHead();
    generateAppRouters();
    generateAppRoutersTail();
    generateEnd();
  }

  void generateImports() {
    imports.add("import 'package:flutter/material.dart';");
    for(var pd in pageDatas) {
      imports += pd.classesInUse.map((e) => 'import "../models/$e.dart";').toList();
      imports.add("import '../pages/${pd.pageWidgetName}.dart;'");
    }
  }

  void generateHead() {}

  void generateRoutes() {
    routes.add("class AppRoutes {");
    routes = pageDatas.map((pd) => "  static const ${pd.pageWidgetName.paramify()} = '/${pd.pageWidgetName}';").toList();
    routes.add("}");
  }

  void generateAppRouterHead() {
    appRouterHead.add("class AppRouter {");
    appRouterHead.add("  static Route<dynamic>? onGenerateRoute(");
    appRouterHead.add("      RouteSettings settings, FirebaseAuth firebaseAuth) {");
    appRouterHead.add("    final args = settings.arguments;");
    appRouterHead.add("    switch (settings.name) {");
  }

  void generateAppRouters() {
    for(var pd in pageDatas) {
      appRouters.add("      case AppRoutes.${pd.pageWidgetName.paramify()}:");
      appRouters.add("        return MaterialPageRoute<dynamic>(");
      appRouters.add("        final mapArgs = args as Map<String, dynamic>;");
      appRouters.addAll(pd.classesInUse.map((e) => "        final ${e.paramify()} = mapArgs['${e.paramify()}'] as $e;"));
      appRouters.add("        return MaterialPageRoute<dynamic>(");
      appRouters.add("          builder: (_) => ${pd.pageWidgetName}(${pd.classesInUse.map((e) => "${e.paramify()}: ${e.paramify()}").toList().join(", ")}),");
      appRouters.add("          settings: settings,");
      appRouters.add("          fullscreenDialog: true,");
      appRouters.add("        );");
    }
  }

  void generateAppRoutersTail() {
    appRouters.add('''      default:
        // TODO: Throw
        return null;
    }
  }
}''');
  }

  void generateEnd() {

  }



}



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


