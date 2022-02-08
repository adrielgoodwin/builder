import 'package:builder/builder/models/field_data.dart';
import 'package:builder/builder/presentation/widget_maker/column_paramaters.dart';
import 'package:builder/builder/state/meta_widget_builder_provider.dart';
import '../../colors/colors.dart';
import 'package:flutter/material.dart';
import '../../MetaWidgetTreeBuilder/meta_widget_tree_builder.dart';
import '../../write_files_api.dart';
import '../../MetaWidgetTreeBuilder/meta_tree.dart';

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

  void buildTree(MetaWidgetBuilderProvider state) {
    String flex1Id = "flex1";
    String row1Id = "row1";
    String flex2Id = "flex2";
    String flex3Id = "flex3";
    String column1Id = "col1";
    String column2Id = "col2";
    String flex4Id = "flex4";
    String flex5Id = "flex5";
    String flex6Id = "flex6";
    String text1Id = "text1";
    String text2Id = "text2";
    String text3Id = "text3";

    var flexNode1 = FlexibleNode(parentId: "", parentBranch: "", id: flex1Id, params: MetaFlexibleParams());
    var rowFork1 = RowFork(parentId: flex1Id, id: row1Id, parentBranch: "", params: MetaRowParams());
    var flexNode2 = FlexibleNode(parentId: row1Id, parentBranch: row1Id, id: flex2Id, params: MetaFlexibleParams());
    var flexNode3 = FlexibleNode(parentId: row1Id, parentBranch: row1Id, id: flex3Id, params: MetaFlexibleParams());
    var column1 = ColumnFork(parentId: flex2Id, id: column1Id, parentBranch: row1Id, params: MetaColumnParams());
    var column2 = ColumnFork(parentId: flex3Id, id: column2Id, parentBranch: row1Id, params: MetaColumnParams());
    var flexNode4 = FlexibleNode(parentId: column1Id, parentBranch: column1Id, id: flex4Id, params: MetaFlexibleParams());
    var flexNode5 = FlexibleNode(parentId: column1Id, parentBranch: column1Id, id: flex5Id, params: MetaFlexibleParams());
    var flexNode6 = FlexibleNode(parentId: column2Id, parentBranch: column2Id, id: flex6Id, params: MetaFlexibleParams());
    var text1 = TextLeaf(id: text1Id, parentBranch: column1Id, parentId: flex4Id, params: MetaTextParams());
    var text2 = TextLeaf(id: text2Id, parentBranch: column1Id, parentId: flex5Id, params: MetaTextParams());
    var text3 = TextLeaf(id: text3Id, parentBranch: column2Id, parentId: flex6Id, params: MetaTextParams());

    var metaTree = MetaTree();

    metaTree.addBranch(flexNode1);
    metaTree.addBranch(flexNode2);
    metaTree.addBranch(flexNode3);
    metaTree.addBranch(flexNode4);
    metaTree.addBranch(flexNode5);
    metaTree.addBranch(flexNode6);

    metaTree.addFork(rowFork1);
    metaTree.addFork(column1);
    metaTree.addFork(column2);

    metaTree.addLeaf(text1);
    metaTree.addLeaf(text2);
    metaTree.addLeaf(text3);

    metaTree.setBuildOrder([column2Id, column1Id, row1Id]);

    state.setMetaTree(metaTree);

    hasInit = true;
  }

  bool hasInit = false;

  @override
  Widget build(BuildContext context) {
    var classState = Provider.of<ClassMakerProvider>(context);
    var metaBuilderState = Provider.of<MetaWidgetBuilderProvider>(context);

    var builtTree = metaBuilderState.builtTree;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          buildTree(metaBuilderState)
          // writeWidgetToFile(metaBuilderState.widgetAsString, metaBuilderState.widgetName);
        },
      ),
      body: Row(children: [
        Flexible(
          flex: 1,
          child: buildSidebar(classState),
        ),
        Flexible(
          flex: 3,
            child: Center(
                child: Material(
          elevation: 22,
          child: Container(
            height: 500,
            width: 300,
            child: Column(
              children: [builtTree],
            ),
          ),
        ))),
      ]),
    );
  }

  Widget buildSidebar(ClassMakerProvider state) {
    var metaBuilderState = Provider.of<MetaWidgetBuilderProvider>(context);
    var metaTree = metaBuilderState.getMetaTree;
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
        hasInit ? ColumnParameters(columnFork: metaTree.forkPoints['col1']! as ColumnFork) : SizedBox(),
        Flexible(
          flex: 2,
          child: Text("Widget Tree"),
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
