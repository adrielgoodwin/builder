// ignore_for_file: non_constant_identifier_names

import 'package:builder/builder/models/field_data.dart';
import 'package:builder/builder/presentation/widget_maker/column_parameters.dart';
import 'package:builder/builder/presentation/widget_maker/row_parameters.dart';
import 'package:builder/builder/state/meta_widget_builder_provider.dart';
import '../../colors/colors.dart';
import 'package:flutter/material.dart';
import '../../MetaWidgetTreeBuilder/meta_widget_tree_builder.dart';
import '../../write_files_api.dart';
import '../../MetaWidgetTreeBuilder/meta_tree.dart';
import 'widget_builder_sidebar.dart';

/// models
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

    var FN1 = FocusNode();
    var FN2 = FocusNode();
    var FN3 = FocusNode();
    var FN4 = FocusNode();
    var FN5 = FocusNode();
    var FN6 = FocusNode();

    var fnR = FocusNode();
    var fnC = FocusNode();
    var fnC2 = FocusNode();

    var flexNode1 = FlexibleNode(
        childrenNodes: ChildrenNodes(), focusNode: FN1, mwbp: state, parentId: "", parentBranch: "", id: flex1Id, params: MetaFlexibleParams(id: flex1Id, focusNode: FN1));
    var flexNode2 = FlexibleNode(
        childrenNodes: ChildrenNodes(), focusNode: FN2, mwbp: state, parentId: row1Id, parentBranch: row1Id, id: flex2Id, params: MetaFlexibleParams(id: flex2Id, focusNode: FN2));
    var flexNode3 = FlexibleNode(
        childrenNodes: ChildrenNodes(), focusNode: FN3, mwbp: state, parentId: row1Id, parentBranch: row1Id, id: flex3Id, params: MetaFlexibleParams(id: flex3Id, focusNode: FN3));
    var flexNode4 = FlexibleNode(
        childrenNodes: ChildrenNodes(),
        focusNode: FN4,
        mwbp: state,
        parentId: column1Id,
        parentBranch: column1Id,
        id: flex4Id,
        params: MetaFlexibleParams(id: flex4Id, focusNode: FN4));
    var flexNode5 = FlexibleNode(
        childrenNodes: ChildrenNodes(),
        focusNode: FN5,
        mwbp: state,
        parentId: column1Id,
        parentBranch: column1Id,
        id: flex5Id,
        params: MetaFlexibleParams(id: flex5Id, focusNode: FN5));
    var flexNode6 = FlexibleNode(
        childrenNodes: ChildrenNodes(),
        focusNode: FN6,
        mwbp: state,
        parentId: column2Id,
        parentBranch: column2Id,
        id: flex6Id,
        params: MetaFlexibleParams(id: flex6Id, focusNode: FN6));
    var rowFork1 =
        RowFork(childrenNodes: ChildrenNodes(), mwbp: state, focusNode: fnR, parentId: flex1Id, id: row1Id, parentBranch: "", params: MetaRowParams(id: row1Id, focusNode: fnR));
    var column1 = ColumnFork(
        childrenNodes: ChildrenNodes(),
        mwbp: state,
        focusNode: fnC,
        parentId: flex2Id,
        id: column1Id,
        parentBranch: row1Id,
        params: MetaColumnParams(id: column1Id, focusNode: fnC));
    var column2 = ColumnFork(
        childrenNodes: ChildrenNodes(),
        mwbp: state,
        focusNode: fnC2,
        parentId: flex3Id,
        id: column2Id,
        parentBranch: row1Id,
        params: MetaColumnParams(id: column2Id, focusNode: fnC2));
    var text1 = TextLeaf(id: text1Id, mwbp: state, parentBranch: column1Id, parentId: flex4Id, params: MetaTextParams(id: text1Id));
    var text2 = TextLeaf(id: text2Id, mwbp: state, parentBranch: column1Id, parentId: flex5Id, params: MetaTextParams(id: text2Id));
    var text3 = TextLeaf(id: text3Id, mwbp: state, parentBranch: column2Id, parentId: flex6Id, params: MetaTextParams(id: text3Id));

    var metaTree = MetaTree();

    // metaTree.addUpdateBranch(flexNode1);
    // metaTree.addUpdateBranch(flexNode2);
    // metaTree.addUpdateBranch(flexNode3);
    // metaTree.addUpdateBranch(flexNode4);
    // metaTree.addUpdateBranch(flexNode5);
    // metaTree.addUpdateBranch(flexNode6);

    metaTree.addUpdateFork(rowFork1);
    // metaTree.addUpdateFork(column1);
    // metaTree.addUpdateFork(column2);
    //
    // metaTree.addUpdateLeaf(text1);
    // metaTree.addUpdateLeaf(text2);
    // metaTree.addUpdateLeaf(text3);

    // metaTree.setBuildOrder([column2Id, column1Id, row1Id]);
    metaTree.setBuildOrder([row1Id]);

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
        const Flexible(
          flex: 1,
          child: WidgetBuilderSidebar(),
        ),
        Flexible(
            flex: 3,
            child: Center(
                child: Material(
              elevation: 22,
              child: Container(
                height: 500,
                width: 300,
                child: SingleChildScrollView(
                  child: builtTree,
                )
              ),
            ))),
      ]),
    );
  }
}

/// Build a sidebar that shows:
/// a) ForkPoints (Column/Row)
/// b) BranchNodes (Flexible)
/// c) Leafs (Text)
