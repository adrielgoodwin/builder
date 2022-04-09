import '../../models/class_data.dart';

String composeMainIOAppScreen(List<ClassData> classDatas) {

  String imports = 'import "package:flutter/material.dart";\n';
  String widgetHead = """
class IoAppScreen extends StatefulWidget {
  const IoAppScreen({Key? key}) : super(key: key);

  @override
  State<IoAppScreen> createState() => _IoAppScreenState();
}

class _IoAppScreenState extends State<IoAppScreen> {
""";
  String stateVariables = """  
  var pageController = PageController();
  var selectedClassIndex = 0;
""";
  String classesList = "";
  String buildMethodBegin = """
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
      children: [
        Flexible(
          child: ListView(
            children: [
              ...classes.map((e) => classListItem(e)).toList(),
            ],
          )
        ),
        Flexible(
          flex: 5,
          child: PageView(
            controller: pageController,
            children: const [ 
""";
  String pages = "";
  String buildMethodEnd = """
            ],
          ),
        ),
      ]),
    );
  }
""";
  String classListItemFunction = """
  Widget classListItem(String className) {
    return ListTile(
      selected: classes.indexOf(className) == selectedClassIndex ? true : false,
      selectedTileColor: Colors.amber,
      title: Text(className),
      onTap: () {
        setState(() {
          selectedClassIndex = classes.indexOf(className);
        });
        pageController.jumpToPage(selectedClassIndex);
      },
    );
  }  
}
""";

  /// data-reliant
  for(var c in classDatas) {
    imports += "import '../record_displays/${c.name}Records.dart';\n";
    classesList += "'${c.name}', ";
    pages += "              ${c.name}Records(),\n";
  }

  String classesListInstantiation = "  var classes = [$classesList];\n";

  return [imports, widgetHead, stateVariables, classesListInstantiation, buildMethodBegin, pages, buildMethodEnd, classListItemFunction].join();

}