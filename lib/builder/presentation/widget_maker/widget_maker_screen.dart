import 'package:builder/builder/models/field_data.dart';
import '../../colors/colors.dart';
import 'package:flutter/material.dart';
import '../../MetaWidgetTreeBuilder/meta_widget_tree_builder.dart';

/// models
import '../../models/metaWidget.dart';
import '../../models/class_data.dart';

/// state
import '../../state/class_maker_provider.dart';
import 'package:provider/provider.dart';

/// What am I trying to do?
/// I am trying to take a data from a class and link it to a widget
/// So to do that ill need what?
/// A widget that is able to be 'linked' to a particular field in a class
/// so Ill need a class that performs the link, it says something like
/// ---
///   Here is a widget, here is the data I would like to use
///   So a widget metaClass that takes a value and has a builder
///   I can start very simple, a class with one field and one text widget
/// ---

/// what data do i need about my classes?
/// do I need an instantiation of the class? not really, I only need references.
///
///
/// I'm trying to show a wysiwyg and also generate files.
///
///

class WidgetMakerScreen extends StatefulWidget {
  const WidgetMakerScreen({Key? key}) : super(key: key);

  @override
  _WidgetMakerScreenState createState() => _WidgetMakerScreenState();
}

class _WidgetMakerScreenState extends State<WidgetMakerScreen> {

  var metaWidgetParameters = MetaWidgetParameters();

  /// A map of meta tree items
  Map<String, MetaTreeItem> metaTreeItems = {
    /// The top of the widget tree
    "TopFlex": MetaTreeItem(
      parentId: '',
      childrenBranches: ['TopRow', 'Column1', 'Column2'],
      children: [''],
      id: 'TopFlex',
      metaWidgetEnum: MetaWidgets.flexible,
      hasChild: true,
      hasChildren: false,
    ),

    /// The first child of the top flex
    "TopRow": MetaTreeItem(
      parentId: 'TopFlex',
      children: [],
      childrenBranches: ['Column2', 'Column1'],
      id: 'TopRow',
      metaWidgetEnum: MetaWidgets.row,
      hasChild: false,
      hasChildren: true,
    ),

    /// The first child of the Top row
    "TopRowFlex1": MetaTreeItem(
      parentId: 'TopRow',
      childrenBranches: [],
      children: ['Column1'],
      id: 'TopRowFlex1',
      metaWidgetEnum: MetaWidgets.flexible,
      hasChild: true,
      hasChildren: false,
    ),

    /// The second child of the top row
    "TopRowFlex2": MetaTreeItem(
      parentId: 'TopRow',
      childrenBranches: [],
      children: ['Column2'],
      id: 'TopRowFlex2',
      metaWidgetEnum: MetaWidgets.flexible,
      hasChild: true,
      hasChildren: false,
    ),
    "Column1": MetaTreeItem(
      parentId: 'TopRowFlex1',
      children: ["Text1"],
      childrenBranches: [],
      id: 'Column1',
      metaWidgetEnum: MetaWidgets.column,
      hasChild: false,
      hasChildren: true,
    ),
    "Column2": MetaTreeItem(
      parentId: 'TopRowFlex2',
      children: ['Text2'],
      childrenBranches: [],
      id: 'Column2',
      metaWidgetEnum: MetaWidgets.column,
      hasChild: false,
      hasChildren: true,
    ),
    "Text2": MetaTreeItem(
      parentId: 'Column2',
      childrenBranches: [],
      children: [],
      id: "Text2",
      metaWidgetEnum: MetaWidgets.text,
      hasChild: false,
      hasChildren: false,
    ),
    "Text1": MetaTreeItem(
      parentId: 'Column1',
      childrenBranches: [],
      children: [],
      id: "Text1",
      metaWidgetEnum: MetaWidgets.text,
      hasChild: false,
      hasChildren: false,
    ),
    "Text13": MetaTreeItem(
      parentId: 'Column1',
      childrenBranches: [],
      children: [],
      id: "Text13",
      metaWidgetEnum: MetaWidgets.text,
      hasChild: false,
      hasChildren: false,
    ),
  };

  List<String> alreadyConsolidated = [];

  /// check if MetaTreeItem is a branch
  bool isBranch(MetaTreeItem mti) => mti.metaWidgetEnum == MetaWidgets.column || mti.metaWidgetEnum == MetaWidgets.row ? true : false;

  late FieldData fieldForUse;

  void setFieldForUse(FieldData fieldData) {
    setState(() {
      fieldForUse = fieldData;
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);
    return Scaffold(
      body: Row(children: [
        Flexible(
          flex: 1,
          child: buildSidebar(state),
        ),
        assembleTree(metaTreeItems, metaWidgetParameters).build(),
        metaWidgetTest.build(),
      ]),
    );
  }

  Widget buildSidebar(ClassMakerProvider state) {
    var metaWidgey = assembleTree(metaTreeItems, metaWidgetParameters);
    print(metaWidgey);

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
