import 'package:builder/builder/models/field_data.dart';
import 'package:builder/builder/state/meta_widget_builder_provider.dart';
import '../../colors/colors.dart';
import 'package:flutter/material.dart';
import '../../MetaWidgetTreeBuilder/meta_widget_tree_builder.dart';
import '../../write_files_api.dart';

/// models
import '../../models/metaWidget.dart';
import '../../models/class_data.dart';

/// state
import '../../state/class_maker_provider.dart';
import 'package:provider/provider.dart';

class WidgetMakerScreen extends StatefulWidget {
  const WidgetMakerScreen({Key? key}) : super(key: key);

  @override
  _WidgetMakerScreenState createState() => _WidgetMakerScreenState();
}

class _WidgetMakerScreenState extends State<WidgetMakerScreen> {

  late FieldData fieldForUse;

  void setFieldForUse(FieldData fieldData) {
    setState(() {
      fieldForUse = fieldData;
    });
  }

  void writeWidgetToFile(String fileText, String fileName) {
    var ftw = FileToWrite(
      name: fileName,
      code: fileText,
      fileLocation: Paths.widgets,
    );
    sendWriteRequest(ftw);
  }

  @override
  Widget build(BuildContext context) {
    var classState = Provider.of<ClassMakerProvider>(context);
    var metaBuilderState = Provider.of<MetaWidgetBuilderProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => writeWidgetToFile(metaBuilderState.widgetAsString, metaBuilderState.widgetName),
      ),
      body: Row(children: [
        Flexible(
          flex: 1,
          child: buildSidebar(classState),
        ),
        // assembleTree(metaTreeItems, metaWidgetParameters).build(),
        // metaWidgetTest.build(),
      ]),
    );
  }

  Widget buildSidebar(ClassMakerProvider state) {
    // var uuid = Uuid();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: () => state.loadRegistries(), child: Text("load classes")),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Classes",
              style: TextStyle(fontSize: 26),
            ),
            IconButton(
                onPressed: () {
                  // print(stepThroughTree('id1'));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                ))
          ],
        ),
        const SizedBox(
          height: 22,
        ),
      ],
    );
  }

  Widget sidebarClassItem(ClassData classData, ClassMakerProvider state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Text(
              classData.name,
              style: TextStyle(fontSize: 16, color: C.orange, fontWeight: FontWeight.w500),
            ),
          ),
          ...classData.fieldData.map((e) => fieldSelector(e)).toList(),
        ],
      ),
    );
  }

  Widget fieldSelector(FieldData fieldData) {
    return GestureDetector(
      onTap: () => setFieldForUse(fieldData),
      child: Row(
        children: [
          Text(
            "  ${fieldData.type}",
            style: TextStyle(color: C.teal, fontWeight: FontWeight.w400),
          ),
          Text(
            "  ${fieldData.name}",
            style: TextStyle(color: C.purple, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
