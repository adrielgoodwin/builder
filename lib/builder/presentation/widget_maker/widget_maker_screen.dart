import 'package:builder/builder/models/field_data.dart';
import '../../colors/colors.dart';
import 'package:flutter/material.dart';

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
  ///
  /// Setting new parameters
  ///
  /// 1. Have something highlighted
  ///

  var metaWidgetParameters = MetaWidgetParameters();

  /// Ok im going to make a tree and then im gonna solve it

  /// A map of meta tree items
  Map<String, MetaTreeItem> metaTreeItems = {
    /// The top of the widget tree
    "TopFlex": MetaTreeItem(
      parentId: '',
      childrenBranches: ['TopRow', 'TopRowFlexColumn1', 'TopRowFlexColumn2'],
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
      childrenBranches: ['TopRowFlex2Column', 'TopRowFlex1Column'],
      id: 'TopRow',
      metaWidgetEnum: MetaWidgets.row,
      hasChild: false,
      hasChildren: true,
    ),

    /// The first child of the Top row
    "TopRowFlex1": MetaTreeItem(
      parentId: 'TopRow',
      childrenBranches: [],
      children: ['TopRowFlex1Column'],
      id: 'TopRowFlex1',
      metaWidgetEnum: MetaWidgets.flexible,
      hasChild: true,
      hasChildren: false,
    ),

    /// The second child of the top row
    "TopRowFlex2": MetaTreeItem(
      parentId: 'TopRow',
      childrenBranches: [],
      children: ['TopRowFlex2Column'],
      id: 'TopRowFlex2',
      metaWidgetEnum: MetaWidgets.flexible,
      hasChild: true,
      hasChildren: false,
    ),
    "TopRowFlex1Column": MetaTreeItem(
      parentId: 'TopRowFlex1',
      children: ["Text1"],
      childrenBranches: [],
      id: 'TopRowFlex1Column',
      metaWidgetEnum: MetaWidgets.column,
      hasChild: false,
      hasChildren: true,
    ),
    "TopRowFlex2Column": MetaTreeItem(
      parentId: 'TopRowFlex2',
      children: ['Text2'],
      childrenBranches: [],
      id: 'TopRowFlex2Column',
      metaWidgetEnum: MetaWidgets.column,
      hasChild: false,
      hasChildren: true,
    ),
    "Text2": MetaTreeItem(
      parentId: 'TopRowFlex2Column',
      childrenBranches: [],
      children: [],
      id: "Text2",
      metaWidgetEnum: MetaWidgets.text,
      hasChild: false,
      hasChildren: false,
    ),
    "Text1": MetaTreeItem(
      parentId: 'TopRowFlex1Column',
      childrenBranches: [],
      children: [],
      id: "Text1",
      metaWidgetEnum: MetaWidgets.text,
      hasChild: false,
      hasChildren: false,
    ),
  };



  var consolidationCount = 1;

  List<String> alreadyConsolidated = [];






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
        assembleTree().build(),
      ]),
    );
  }

  Widget buildSidebar(ClassMakerProvider state) {
    var metaWidgey = assembleTree();
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
