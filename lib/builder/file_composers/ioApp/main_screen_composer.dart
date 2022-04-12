import '../../models/class_data.dart';

String composeMainIOAppScreen(List<ClassData> classDatas) {

  String imports = '''import "package:flutter/material.dart";
import '../../state/class_maker_provider.dart';
import 'package:provider/provider.dart';
''';
  String widgetHead = """
class IoAppScreen extends StatefulWidget {
  IoAppScreen({Key? key, required this.rebuiltMessage}) : super(key: key);

  final String rebuiltMessage;
  @override
  State<IoAppScreen> createState() => _IoAppScreenState();
}

class _IoAppScreenState extends State<IoAppScreen> {
""";
  String stateVariables = """  
  var recordPageController = PageController();
  var formPageController = PageController();
  var selectedClassIndex = 0;
  var selectedFormIndex = 0;
""";
  String classesList = "";
  String buildMethodBegin = """
@override
  Widget build(BuildContext context) {
    var rebuildMessage = Provider.of<ClassMakerProvider>(context).rebuiltMessage;
    return Scaffold(
      body: Row(
      children: [
        Flexible(
          child: ListView(
            children: [
            Text(rebuildMessage),
              ...classes.map((e) => classListItem(e)).toList(),
            ],
          )
        ),

""";

  String recordsPage = """
        Flexible(
          flex: 3,
          child: PageView(
            controller: recordPageController,
            children: const [   
""";

  String buildMethodEnd = """
          ]));
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
        recordPageController.jumpToPage(selectedClassIndex);
      },
      onLongPress: () {
        setState(() {
          selectedFormIndex = classes.indexOf(className) + 1;
        });
        formPageController.jumpToPage(selectedFormIndex);
      }
    );
  }  
}
""";

  String formPage = """
        Flexible(
          flex: 3,
          child: PageView(
            controller: formPageController,
            children: const [ 
              Center(child: Text('=)'),),\n
""";

  /// data-reliant
  for(var c in classDatas) {
    imports += "import '../record_displays/${c.name}Records.dart';\n";
    imports += "import '../forms/${c.name}Form.dart';\n";
    classesList += "'${c.name}', ";
    recordsPage += "              ${c.name}Records(),\n";
    formPage += "              ${c.name}Form(),\n";
  }

  recordsPage += """
            ],
          ),
        ), 
""";

  formPage += """ 
            ],
          ),
        ),
""";

  String classesListInstantiation = "  var classes = [$classesList];\n";

  return [imports, widgetHead, stateVariables, classesListInstantiation, buildMethodBegin, recordsPage, formPage, buildMethodEnd, classListItemFunction].join();

}