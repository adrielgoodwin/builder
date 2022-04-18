import "package:flutter/material.dart";
import '../../state/class_maker_provider.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../record_displays/NewClassyRecords.dart';
import '../forms/NewClassyForm.dart';
class IoAppScreen extends StatefulWidget {
  IoAppScreen({Key? key, required this.rebuiltMessage}) : super(key: key);

  final String rebuiltMessage;
  @override
  State<IoAppScreen> createState() => _IoAppScreenState();
}

class _IoAppScreenState extends State<IoAppScreen> {
  var recordPageController = PageController();
  var formPageController = PageController();
  var selectedClassIndex = 0;
  var selectedFormIndex = 0;
  var classes = ['NewClassy', ];
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
            TextButton(child: Text("load"), onPressed: () => Provider.of<MainProvider>(context, listen: false).loadDB(),),
              ...classes.map((e) => classListItem(e)).toList(),
            ],
          )
        ),

        Flexible(
          flex: 3,
          child: PageView(
            controller: recordPageController,
            children: const [   
              NewClassyRecords(),
            ],
          ),
        ), 
        Flexible(
          flex: 3,
          child: PageView(
            controller: formPageController,
            children: const [ 
              Center(child: Text('=)'),),

              NewClassyForm(),
            ],
          ),
        ),
          ]));
  }
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
