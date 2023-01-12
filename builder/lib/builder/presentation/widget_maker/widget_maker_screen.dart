// ignore_for_file: non_constant_identifier_names

import 'package:builder/builder/models/field_data.dart';
import 'package:builder/builder/state/meta_widget_builder_provider.dart';
import 'package:flutter/material.dart';
import '../../MetaWidgetTreeBuilder/meta_tree.dart';
import 'widget_builder_sidebar.dart';

/// models

/// state
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

  void buildTree(MetaWidgetBuilderProvider state) {
    String flex1Id = "flex1";
    String row1Id = "row1";

    var fnR = FocusNode();

    var rowFork1 = RowFork(
      childrenNodes: ChildrenNodes(),
      mwbp: state,
      focusNode: fnR,
      parentId: flex1Id,
      id: row1Id,
      parentType: "",
      params: MetaRowParams(id: row1Id, focusNode: fnR),
    );

    var metaTree = MetaTree();

    metaTree.addUpdateFork(rowFork1);
    metaTree.setBuildOrder([row1Id]);
    state.setMetaTree(metaTree);
  }

  @override
  Widget build(BuildContext context) {
    var metaBuilderState = Provider.of<MetaWidgetBuilderProvider>(context);

    var builtTree = metaBuilderState.builtTree;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {buildTree(metaBuilderState)},
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(children: [
          const Flexible(
            flex: 2,
            child: WidgetBuilderSidebar(),
          ),
          Flexible(
              flex: 5,
              child: Center(
                  child: Material(
                elevation: 22,
                child: SizedBox(
                    height: 500,
                    width: 300,
                    child: SingleChildScrollView(
                      child: builtTree,
                    )),
              ))),
        ]),
      ),
    );
  }
}

/// Build a sidebar that shows:
/// a) ForkPoints (Column/Row)
/// b) BranchNodes (Flexible)
/// c) Leafs (Text)
