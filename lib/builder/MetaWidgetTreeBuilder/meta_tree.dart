// ignore_for_file: avoid_print

import 'package:builder/builder/state/meta_widget_builder_provider.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../models/field_data.dart';
import '../models/class_data.dart';
import '../extensions.dart';

/// Such sentiment
/// https://www.youtube.com/watch?v=gUUH8xzu41s&ab_channel=Vanilla
///
///

// Stuff to do
// properly populate children nodes class on create
// decide all possible build situations
// make a map that has buttons to build methods
//
// get all class-datas - Show class datas in
// selected field variable
// onclick of text field, set field data to meta text,
// add classes in use to classes in use
// generate simple provider
// remember to have import in widget file
// place provider reference inside build function

Map<String, Function> buildMethods = {
  'Flexible': () {},
};

List<Widget> buildMethodButtons() {
  return buildMethods.map((key, value) => MapEntry(key, ElevatedButton(
    onPressed: () => value(),
    child: Text(key),
  ))).values.toList();
}

var uuid = const Uuid();

class MetaTree {
  Map<String, ForkPoint> forkPoints = {};

  Map<String, BranchNode> branchNodes = {};

  Map<String, Leaf> leafs = {};

  List<String> forkBuildOrder = ['row1'];

  late MetaWidget topMetaWidget;

  ///     \/     \/\     /\/     \\/     \\/\     /\
  ///-|    m e t a    t r e e    b u i l d i n g    |-]
  ///     /\     /\/     \/\     //\     //\/     /\

  void setBuildOrder(List<String> buildOrder) => forkBuildOrder = buildOrder;

  void addUpdateFork(ForkPoint newForkPoint) {
    forkPoints[newForkPoint.id] = newForkPoint;
  }

  void addUpdateBranch(BranchNode newBranchNode) {
    branchNodes[newBranchNode.id] = newBranchNode;
  }

  void addUpdateLeaf(Leaf newLeaf) {
    leafs[newLeaf.id] = newLeaf;
  }

  ///     \/     \/\     /\/     \\/     \\/\     /\
  ///
  ///-|    m e t a    t r e e    g e t t e r s    |-]
  ///
  ///     /\     /\/     \/\     //\     //\/     /\

  List<FlexibleNode> get selectedFlexibles => _selectedFlexibles;

  List<FlexibleNode> _selectedFlexibles = [];

  void setCurrentlySelectedFlexibles(String id) {
    /// avoid re-ordering
    if (_selectedFlexibles.isNotEmpty) {
      if ([_selectedFlexibles.firstWhere((element) => element.id == id)].isEmpty) {
        _selectedFlexibles = getSiblingBranches(id).values.map((e) => e as FlexibleNode).toList();
      }
    }
  }

  Map<String, BranchNode> getSiblingBranches(String id, [bool include = true]) {
    var parentId = branchNodes[id]!.parentId;
    Map<String, BranchNode> siblings = {};
    branchNodes.values.where((y) => y.parentId == parentId).toList().forEach((y) => siblings[y.id] = y);
    if (include) return siblings;
    siblings.removeWhere((key, value) => key == id);
    return siblings;
  }

  ///     \/     \/\     /\/     \\/     \\/\     /\
  ///
  ///-|    m e t a   w i d g e t    b u i l d i n g    |-]
  ///
  ///     /\     /\/     \/\     //\     //\/     /\

  void reset() {
    for (var forkPoint in forkPoints.values) {
      forkPoint.children = [];
    }
  }

  MetaWidget build() {
    reset();
    buildLeafsUpwards();
    buildForks();
    return topMetaWidget;
  }

  void buildForks() {
    for (var forkKey in forkBuildOrder) {
      if (forkKey == forkBuildOrder[forkBuildOrder.length - 1]) {
        // print("isTop, forkKey: $forkKey");
        buildForkAndBeyond(forkKey, true);
      } else {
        buildForkAndBeyond(forkKey, false);
      }
    }

  }

  MetaWidget buildUp(MetaWidget childNode, BranchNode parentNode) {
    parentNode.child = childNode;
    if (parentNode.parentBranch == parentNode.parentId || parentNode.parentId.isEmpty) {
      return parentNode.build();
    }
    return buildUp(parentNode.build(), branchNodes[parentNode.parentId]!);
  }

  void buildLeafsUpwards() {
    if(leafs.isNotEmpty) {
      for (var leaf in leafs.values) {
        if(leaf.parentBranch != leaf.parentId) {
          forkPoints[leaf.parentBranch]!.addChild(buildUp(leaf.build(), branchNodes[leaf.parentId]!));
        } else {
          forkPoints[leaf.parentBranch]!.addChild(leaf.build());
        }
      }
    }
  }

  void buildForkAndBeyond(String forkKey, bool isTop) {
    if (!isTop) {
      forkPoints[forkPoints[forkKey]!.parentBranch]!.addChild(buildUp(forkPoints[forkKey]!.build(), branchNodes[forkPoints[forkKey]!.parentId]!));
    } else {
      topMetaWidget = forkPoints[forkKey]!.build();
    }
  }
}

class ChildrenNodes {
  List<ForkPoint> forkPoints;
  List<BranchNode> branchNodes;
  List<Leaf> leafs;

  ChildrenNodes({this.forkPoints = const [], this.branchNodes = const [], this.leafs = const []});
}

///  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0

///     ///
/// /// /// ///
///
///  f o r k s
///
/// /// /// ///

class ForkPoint {
  ForkPoint(
      {required this.id, required this.focusNode, required this.childrenNodes, required this.parentId, required this.mwbp, required this.parentBranch, this.children = const []});

  final String id;
  final String parentId;
  final String parentBranch;
  final FocusNode focusNode;
  ChildrenNodes childrenNodes;
  List<MetaWidget> children;
  MetaWidgetBuilderProvider mwbp;
  Map<String, Function> get builderFunctions => {
    "Add child flexible": () => addChildFlexible(),
    "Add child text": () => addTextChild(),
  };

  void addChild(MetaWidget newChild) => children = [...children, newChild];

  MetaWidget build() {
    return const MetaWidget();
  }

  void deleteWithChildren() {
    mwbp.deleteAllChildren(childrenNodes);
    mwbp.deleteForks([this]);
  }

  void addChildFlexible() {
    var newFocusNode = FocusNode();
    var newId = "flexible_${uuid.v4().toString()}";
    var newFlexible = FlexibleNode(
      flexibleSelectedState: FlexibleSelectedState.selected,
        focusNode: newFocusNode,
        mwbp: mwbp,
        childrenNodes: ChildrenNodes(),
        parentId: id,
        parentBranch: id,
        id: newId,
        params: MetaFlexibleParams(id: newId, focusNode: newFocusNode));
    addChild(newFlexible.build());
    mwbp.addUpdateBranches([newFlexible]);
  }

  void addTextChild() {
    var textId = "Text_${uuid.v4().toString()}";
    var textLeaf = TextLeaf(id: textId, mwbp: mwbp, parentBranch: id, parentId: id, params: MetaTextParams(id: textId, textStyle: MetaTextStyle()));
    mwbp.addUpdateLeafs([textLeaf]);
  }

  void requestFocus() {}

  void setSelectedStateAsParent() {}
}

class RowFork extends ForkPoint {
  RowFork(
      {required String parentId,
      required ChildrenNodes childrenNodes,
      required FocusNode focusNode,
      required MetaWidgetBuilderProvider mwbp,
      required String id,
      required String parentBranch,
      required this.params})
      : super(id: id, parentId: parentId, childrenNodes: childrenNodes, mwbp: mwbp, focusNode: focusNode, parentBranch: parentBranch);

  MetaRowParams params;

  @override
  build() {
    params.children = children;
    return MetaRow(params, mwbp);
  }

  @override
  void requestFocus() {
    params.selectedState = RowSelectedState.selected;
    focusNode.requestFocus();
    mwbp.rebuildTree();
  }

  void handleFocusLoss() {
    params.selectedState = RowSelectedState.notSelected;
    mwbp.rebuildTree();
  }

  @override
  void setSelectedStateAsParent() {
    params.selectedState = RowSelectedState.childrenSelected;
    mwbp.rebuildTree();
  }
}

class ColumnFork extends ForkPoint {
  ColumnFork(
      {required String parentId,
      required ChildrenNodes childrenNodes,
      required FocusNode focusNode,
      required MetaWidgetBuilderProvider mwbp,
      required String id,
      required String parentBranch,
      required this.params})
      : super(id: id, childrenNodes: childrenNodes, parentId: parentId, focusNode: focusNode, mwbp: mwbp, parentBranch: parentBranch);

  MetaColumnParams params;

  @override
  build() {
    params.children = children;
    return MetaColumn(params, mwbp);
  }

  @override
  void requestFocus() {
    params.selectedState = ColumnSelectedState.selected;
    focusNode.requestFocus();
    mwbp.rebuildTree();
  }

  void handleFocusLoss() {
    params.selectedState = ColumnSelectedState.notSelected;
    mwbp.rebuildTree();
  }

  @override
  void setSelectedStateAsParent() {
    params.selectedState = ColumnSelectedState.childrenSelected;
    // mwbp.rebuildTree();
  }
}

///  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0

/// /// /// /// /// ///
///    /   /   /   /
///  b r a n c h e s
///  /   /   /   /
/// /// /// /// /// ///

class BranchNode {
  BranchNode(
      {required this.id,
      required this.childrenNodes,
      required this.mwbp,
      required this.focusNode,
      required this.parentId,
      required this.parentBranch,
      this.child = const MetaSizedBox()});

  final String id;
  final String parentId;
  final String parentBranch;
  ChildrenNodes childrenNodes;
  final FocusNode focusNode;
  MetaWidget child;
  final MetaWidgetBuilderProvider mwbp;

  MetaWidget build() {
    return const MetaWidget();
  }

  void requestFocus() {}
}

class FlexibleNode extends BranchNode {
  FlexibleNode({
    required String parentId,
    required FocusNode focusNode,
    required MetaWidgetBuilderProvider mwbp,
    this.flexibleSelectedState = FlexibleSelectedState.notSelected,
    required String id,
    required ChildrenNodes childrenNodes,
    required String parentBranch,
    required this.params,
  }) : super(id: id, parentId: parentId, childrenNodes: childrenNodes, focusNode: focusNode, mwbp: mwbp, parentBranch: parentBranch);

  MetaFlexibleParams params;
  FlexibleSelectedState flexibleSelectedState;

  @override
  build() {
    params.child = child;
    return MetaFlexible(params, mwbp);
  }

  void deleteWithChildren() {
    mwbp.deleteAllChildren(childrenNodes);
    mwbp.deleteBranches([this]);
  }

  void increaseSize() {
    if (flexibleSelectedState != FlexibleSelectedState.locked) {
      Map<String, FlexibleNode> flexibles = mwbp.metaTree.getSiblingBranches(id).map((key, value) => MapEntry(key, value as FlexibleNode));
      flexibles.removeWhere((key, y) => y.flexibleSelectedState == FlexibleSelectedState.locked);
      if (flexibles.length > 1) {
        var i = flexibles.values.length - 1;
        flexibles[id]!.params.flex = flexibles[id]!.params.flex + i;
        for (var sibling in flexibles.values) {
          if (sibling.id != id) {
            sibling.params.flex = sibling.params.flex - 1;
            flexibles[sibling.id] = sibling;
          }
        }
        mwbp.addUpdateBranches(flexibles.values.toList());
      }
    }
  }

  void addChildColumn() {
    FocusNode focusNode = FocusNode();
    var columnId = newColumnId();
    var parentNode = mwbp.metaTree.branchNodes[id]!;
    var childrenNodes = parentNode.childrenNodes;
    childrenNodes.branchNodes = [...childrenNodes.branchNodes, parentNode];
    var newColumn = ColumnFork(
      childrenNodes: childrenNodes,
      mwbp: mwbp,
      focusNode: focusNode,
      parentId: id,
      id: columnId,
      parentBranch: parentNode.parentBranch,
      params: MetaColumnParams(id: columnId, focusNode: focusNode),
    );
    mwbp.addUpdateForks([newColumn]);
  }

  void addChildRow() {
    FocusNode focusNode = FocusNode();
    var rowId = newRowId();
    var parentNode = mwbp.metaTree.branchNodes[id]!;
    var childrenNodes = parentNode.childrenNodes;
    childrenNodes.branchNodes = [...childrenNodes.branchNodes, parentNode];
    var newColumn = RowFork(
      childrenNodes: childrenNodes,
      mwbp: mwbp,
      focusNode: focusNode,
      parentId: id,
      id: rowId,
      parentBranch: parentNode.parentBranch,
      params: MetaRowParams(id: rowId, focusNode: focusNode),
    );
    mwbp.addUpdateForks([newColumn]);
  }

  void decreaseSize() {
    if (flexibleSelectedState != FlexibleSelectedState.locked) {
      Map<String, FlexibleNode> flexibles = mwbp.metaTree.getSiblingBranches(id).map((key, value) => MapEntry(key, value as FlexibleNode));
      flexibles.removeWhere((key, y) => y.flexibleSelectedState == FlexibleSelectedState.locked);
      var i = flexibles.values.length - 1;
      flexibles[id]!.params.flex = flexibles[id]!.params.flex - i;
      for (var sibling in flexibles.values) {
        if (sibling.id != id) {
          sibling.params.flex = sibling.params.flex + 1;
          flexibles[sibling.id] = sibling;
        }
      }
      mwbp.addUpdateBranches(flexibles.values.toList());
    }
  }

  @override
  void requestFocus() {
    mwbp.metaTree.forkPoints[parentId]!.setSelectedStateAsParent();
    params.selectedState = FlexibleSelectedState.selected;
    // var sibs = mwbp.metaTree.getSiblingBranches(id, false).values.map((e) => e as FlexibleNode);
    // for (var s in sibs) {
    //   if (s.flexibleSelectedState != FlexibleSelectedState.locked) s.setSelectedState(FlexibleSelectedState.siblingSelected, false);
    // }
    mwbp.metaTree.setCurrentlySelectedFlexibles(id);
    mwbp.rebuildTree();
  }

  void handleFocusLoss() {
    // if ([mwbp.metaTree.selectedFlexibles.firstWhere((element) => element.id == id)].isEmpty) {
    setSelectedState(FlexibleSelectedState.notSelected);
    // }
  }

  void setSelectedState(FlexibleSelectedState newState, [bool rebuild = true]) {
    params.selectedState = newState;
    if (rebuild) mwbp.rebuildTree();
  }

  void toggleLockedState() {
    if (params.selectedState == FlexibleSelectedState.selected) {
      params.selectedState = FlexibleSelectedState.locked;
    } else if (params.selectedState == FlexibleSelectedState.locked) {
      params.selectedState = FlexibleSelectedState.selected;
    }
    mwbp.rebuildTree();
  }
}

///  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0

/// \\\
///      \\\
/// l e a f s \\\
///\\        //\\\
///

class Leaf {
  Leaf({required this.id, required this.mwbp, required this.parentBranch, this.parentId = ""});

  final String id;
  String parentId;
  final String parentBranch;
  MetaWidgetBuilderProvider mwbp;

  MetaWidget build() {
    return const MetaWidget();
  }

  void requestFocus() {}
}

enum TextSS { selected, notSelected }

class TextLeaf extends Leaf {
  TextLeaf({required String id, required MetaWidgetBuilderProvider mwbp, this.selectedState = TextSS.notSelected, required String parentBranch, required String parentId, required this.params})
      : super(id: id, mwbp: mwbp, parentBranch: parentBranch, parentId: parentId);

  MetaTextParams params;
  TextSS selectedState;

  void handleFocusLoss() {
    selectedState = TextSS.notSelected;
    mwbp.rebuildTree();
  }

  @override
  void requestFocus() {
    selectedState = TextSS.selected;
    mwbp.rebuildTree();
  }

  void updateStyle(MetaTextStyle mts) {
    params.textStyle = mts;
    mwbp.rebuildTree();
  }

  void updateField(FieldData fieldData) {
    params.fieldData = fieldData;
    mwbp.rebuildTree();
  }

  @override
  MetaWidget build() {
    return MetaText(params);
  }
}

/// cool things
/// setSystemOverlayUistyle
/// sliver app bar
/// cupertino activity indicator
/// selectable text
/// hero for images
/// slider
/// chip
/// transform matrix 4 identity for 3d stuff
/// gridview
///


enum dataWidgetType { single, list }

// create proper builder for widget...
// maybe this is done in the page builder screen


class WidgetBuilderWithData {
  WidgetBuilderWithData({required this.nameOfWidget, required this.topWidget, required this.classesInUse});

  String nameOfWidget;
  MetaWidget topWidget;
  List<ClassData> classesInUse;

  String writeAsString() {
    String constructorFields = classesInUse.map((e) => "required ${e.name}").toList().join(", ");
    String fields = classesInUse.map((e) => '  final ${e.name} ${e.name.deCapitalize()};').join('\n');
    String imports = classesInUse.map((e) => '  import"../data_classes/${e.name}.dart";').join('\n');
    return '''$imports
class $nameOfWidget extends StatelessWidget {
  $nameOfWidget({$constructorFields});
  
  $fields

  @override
  Widget build(BuildContext context) {
    return ${topWidget.writeAsString()};
  }
}    
''';
  }
}

/// Base MetaWidget class for extending all others
class MetaWidget {
  const MetaWidget();

  Widget build() => Column();

  String writeAsString() => "";
}

///text))/((/))/(())/((/))/((/))/((/))
///
///
///
///
///
///
///
///
///
///
///
///

class MetaTextStyle {
  MetaTextStyle({this.fontSize = 12, this.weight = FontWeight.w200, this.style = FontStyle.normal});

  double fontSize;
  FontWeight weight;
  FontStyle style;

  TextStyle build() {
    return TextStyle(fontSize: fontSize, fontWeight:  weight, fontStyle: style);
  }

  String writeAsString() {
    return 'TextStyle(fontSize: $fontSize, fontWeight: $weight, fontStyle: $style)';
  }
}

Map<TextSS, Color> textSSColors = {
  TextSS.selected: Colors.green,
  TextSS.notSelected: Colors.white30
};

class MetaTextParams {
  MetaTextParams({required this.id, this.fieldData, this.selectedState = TextSS.notSelected, required this.textStyle});

  final String id;
  TextSS selectedState;
  FieldData? fieldData;
  MetaTextStyle textStyle;
}

class MetaText extends MetaWidget {
  MetaText(this.params);

  bool isSelected = false;

  final MetaTextParams params;

  String text() => params.fieldData != null ? params.fieldData!.name : "A text field";

  @override
  Widget build() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1, color: textSSColors[params.selectedState]!)),
      child: Text(
        text(),
        style: params.textStyle.build(),
      ),
    );
  }

  @override
  String writeAsString() {
    if (params.fieldData != null) {
      return 'Text(\${${params.fieldData!.parentClass}.${params.fieldData!.name}}, style: ${params.textStyle.writeAsString()}';
    } else {
      return 'Text("TextWidget", style: ${params.textStyle.writeAsString()}';
    }
  }
}

///
/// MetaWidgets that branch

enum RowSelectedState { selected, parentSelected, notSelected, childrenSelected }

Map<RowSelectedState, Color> rowSelectedColors = {
  RowSelectedState.selected: Colors.green,
  RowSelectedState.parentSelected: Colors.blueAccent,
  RowSelectedState.notSelected: Colors.white30,
  RowSelectedState.childrenSelected: Colors.purple,
};

class ChangeMainAxisAlignmentIntent extends Intent {
  const ChangeMainAxisAlignmentIntent(this.mainAxisAlignment, this.forkId);

  final MainAxisAlignment mainAxisAlignment;
  final String forkId;
}

class ChangeMainAxisAlignmentAction extends Action<ChangeMainAxisAlignmentIntent> {
  ChangeMainAxisAlignmentAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(ChangeMainAxisAlignmentIntent intent) {
    print("detected keypress");
    var rowFork = mwbp.metaTree.forkPoints[intent.forkId] as RowFork;
    rowFork.params.mainAxisAlignment = intent.mainAxisAlignment;
    mwbp.addUpdateForks([rowFork]);
  }
}

class FocusFirstChildIntent extends Intent {
  const FocusFirstChildIntent(this.id);

  final String id;
}

class FocusFirstChildAction extends Action<FocusFirstChildIntent> {
  FocusFirstChildAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(FocusFirstChildIntent intent) {
    var firstChildId = mwbp.metaTree.branchNodes.values.firstWhere((branchNode) => branchNode.parentId == intent.id).id;
    mwbp.metaTree.branchNodes[firstChildId]!.requestFocus();
  }
}

class AddChildIntent extends Intent {
  const AddChildIntent(this.id);

  final String id;
}

class AddChildAction extends Action<AddChildIntent> {
  AddChildAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(AddChildIntent intent) {
    mwbp.metaTree.forkPoints[intent.id]!.addChildFlexible();
  }
}

/// Add data to text fields

class MetaRowParams {
  MetaRowParams({
    this.children = const [],
    this.id = "defaultId",
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.selectedState = RowSelectedState.notSelected,
    required this.focusNode,
  });

  String id;
  List<MetaWidget> children;
  FocusNode focusNode;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  RowSelectedState selectedState;
}

class MetaRow extends MetaWidget {
  MetaRow(this.params, this.mwbp);

  final MetaRowParams params;
  final MetaWidgetBuilderProvider mwbp;

  @override
  Widget build() {
    // print("Row Params: SelectedState: ${params.selectedState}");
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.keyZ): ChangeMainAxisAlignmentIntent(MainAxisAlignment.start, params.id),
        LogicalKeySet(LogicalKeyboardKey.keyX): ChangeMainAxisAlignmentIntent(MainAxisAlignment.center, params.id),
        LogicalKeySet(LogicalKeyboardKey.keyC): ChangeMainAxisAlignmentIntent(MainAxisAlignment.spaceEvenly, params.id),
        LogicalKeySet(LogicalKeyboardKey.keyV): ChangeMainAxisAlignmentIntent(MainAxisAlignment.spaceBetween, params.id),
        LogicalKeySet(LogicalKeyboardKey.keyB): ChangeMainAxisAlignmentIntent(MainAxisAlignment.end, params.id),
        LogicalKeySet(LogicalKeyboardKey.enter): FocusFirstChildIntent(params.id),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN): AddChildIntent(params.id),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ChangeMainAxisAlignmentIntent: ChangeMainAxisAlignmentAction(mwbp),
          FocusFirstChildIntent: FocusFirstChildAction(mwbp),
          AddChildIntent: AddChildAction(mwbp),
        },
        child: Focus(
          focusNode: params.focusNode,
          autofocus: true,
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 1, color: rowSelectedColors[params.selectedState]!)),
            child: Row(
              children: params.children.map((e) => e.build()).toList(),
              mainAxisAlignment: params.mainAxisAlignment,
              crossAxisAlignment: params.crossAxisAlignment,
            ),
          ),
        ),
      ),
    );
  }

  @override
  String writeAsString() {
    List<String> children = params.children.map((e) => e.writeAsString()).toList();
    String joinedChildren = children.join(", \n");
    return '''
    Row(
      children: [
        $joinedChildren
      ],
      mainAxisAlignment: mrp.mainAxisAlignment,
      crossAxisAlignment: mrp.crossAxisAlignment,
    );
    ''';
  }
}

///))/((/))\\\
///           /((/)
///
///
///
///
///
///
///))/Column/((/))

enum ColumnSelectedState { selected, parentSelected, notSelected, childrenSelected }

Map<ColumnSelectedState, Color> columnSelectedColors = {
  ColumnSelectedState.selected: Colors.red,
  ColumnSelectedState.parentSelected: Colors.blueAccent,
  ColumnSelectedState.notSelected: Colors.white,
  ColumnSelectedState.childrenSelected: Colors.purple,
};

class MetaColumnParams {
  MetaColumnParams(
      {this.children = const [],
      required this.focusNode,
      required this.id,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.selectedState = ColumnSelectedState.notSelected});

  ColumnSelectedState selectedState;
  final FocusNode focusNode;
  final String id;
  List<MetaWidget> children;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
}

class MetaColumn extends MetaWidget {
  MetaColumn(this.params, this.mwbp);

  MetaWidgetBuilderProvider mwbp;

  final MetaColumnParams params;

  @override
  Widget build() {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN): AddChildIntent(params.id),
      },
      child: Actions(
        actions: {
          AddChildIntent: AddChildAction(mwbp),
        },
        child: Focus(
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 1, color: columnSelectedColors[params.selectedState]!)),
            child: Column(
              children: params.children.map((e) => e.build()).toList(),
              mainAxisAlignment: params.mainAxisAlignment,
              crossAxisAlignment: params.crossAxisAlignment,
            ),
          ),
        ),
      ),
    );
  }
}

///
/// MetaWidgets that are containers
///

///))/((/))/((/))/((/))
///
///
///
///))/Flexible/((/))
///
///
///
///
///

enum FlexibleSelectedState { selected, siblingSelected, parentSelected, locked, notSelected }

Map<FlexibleSelectedState, Color> flexibleSelectedColors = {
  FlexibleSelectedState.selected: Colors.green,
  FlexibleSelectedState.siblingSelected: Colors.white,
  FlexibleSelectedState.parentSelected: Colors.white,
  FlexibleSelectedState.locked: Colors.yellow,
  FlexibleSelectedState.notSelected: Colors.white,
};

class IncreaseFlexibleAmountIntent extends Intent {
  const IncreaseFlexibleAmountIntent(this.flexibleId);

  final String flexibleId;
}

class DecreaseFlexibleAmountIntent extends Intent {
  const DecreaseFlexibleAmountIntent(this.flexibleId);

  final String flexibleId;
}

class FocusParentIntent extends Intent {
  const FocusParentIntent(this.parentId);

  final String parentId;
}

class ToggleFlexibleLockedStateIntent extends Intent {
  const ToggleFlexibleLockedStateIntent(this.flexibleNodeId);

  final String flexibleNodeId;
}

class ToggleFlexibleLockedStateAction extends Action<ToggleFlexibleLockedStateIntent> {
  ToggleFlexibleLockedStateAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(ToggleFlexibleLockedStateIntent intent) {
    var fn = mwbp.metaTree.branchNodes[intent.flexibleNodeId]! as FlexibleNode;
    fn.toggleLockedState();
  }
}

class IncreaseFlexibleAmountAction extends Action<IncreaseFlexibleAmountIntent> {
  IncreaseFlexibleAmountAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(IncreaseFlexibleAmountIntent intent) {
    (mwbp.metaTree.branchNodes[intent.flexibleId]! as FlexibleNode).increaseSize();
  }
}

class DecreaseFlexibleAmountAction extends Action<DecreaseFlexibleAmountIntent> {
  DecreaseFlexibleAmountAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(DecreaseFlexibleAmountIntent intent) {
    (mwbp.metaTree.branchNodes[intent.flexibleId]! as FlexibleNode).decreaseSize();
  }
}

class FocusParentAction extends Action<FocusParentIntent> {
  FocusParentAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(FocusParentIntent intent) {
    mwbp.metaTree.forkPoints[intent.parentId]!.requestFocus();
  }
}

class AddChildToFlexibleIntent extends Intent {
  const AddChildToFlexibleIntent(this.id, this.type);

  final String type;
  final String id;
}

class AddChildToFlexibleAction extends Action<AddChildToFlexibleIntent> {
  AddChildToFlexibleAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(AddChildToFlexibleIntent intent) {
    if (intent.type == 'column') {
    } else if (intent.type == 'row') {}
  }
}

class SelectNextFlexibleIntent extends Intent {
  const SelectNextFlexibleIntent(this.id, this.directionValue);

  final String id;
  final int directionValue;
}

class SelectNextFlexibleAction extends Action<SelectNextFlexibleIntent> {
  SelectNextFlexibleAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(SelectNextFlexibleIntent intent) {
    var sf = mwbp.metaTree.selectedFlexibles;
    var i = sf.indexOf(mwbp.metaTree.branchNodes[intent.id]! as FlexibleNode);
    var ni = i + intent.directionValue;
    if (ni < sf.length && ni >= 0) {
      sf[ni].requestFocus();
    }
  }
}

class MetaFlexibleParams {
  MetaFlexibleParams({this.flex = 7, required this.focusNode, this.id = "defaultId", this.selectedState = FlexibleSelectedState.notSelected, this.child = const MetaSizedBox()});

  final FocusNode focusNode;
  FlexibleSelectedState selectedState;
  String id;
  int flex;
  MetaWidget child;
}

class MetaFlexible extends MetaWidget {
  MetaFlexible(this.params, this.mwbp);

  MetaFlexibleParams params;
  final MetaWidgetBuilderProvider mwbp;

  @override
  Widget build() {
    return Flexible(
      flex: params.flex,
      child: params.child.build(),
    );
  }

// class MetaFlexible extends MetaWidget {
//   MetaFlexible(this.params, this.mwbp);
//
//   MetaFlexibleParams params;
//   final MetaWidgetBuilderProvider mwbp;
//
//   @override
//   Widget build() {
//     return Flexible(
//       flex: params.flex,
//       child: Shortcuts(
//         shortcuts: {
//           LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.arrowUp): IncreaseFlexibleAmountIntent(params.id),
//           LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.arrowDown): DecreaseFlexibleAmountIntent(params.id),
//           LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.arrowRight): SelectNextFlexibleIntent(params.id, 1),
//           LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.arrowLeft): SelectNextFlexibleIntent(params.id, -1),
//           LogicalKeySet(LogicalKeyboardKey.space): FocusParentIntent(mwbp.metaTree.branchNodes[params.id]!.parentId),
//           LogicalKeySet(LogicalKeyboardKey.keyL): ToggleFlexibleLockedStateIntent(params.id),
//           LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyR): AddChildToFlexibleIntent(params.id, 'row'),
//           LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyC): AddChildToFlexibleIntent(params.id, 'column'),
//         },
//         child: Actions(
//           actions: <Type, Action<Intent>>{
//             IncreaseFlexibleAmountIntent: IncreaseFlexibleAmountAction(mwbp),
//             DecreaseFlexibleAmountIntent: DecreaseFlexibleAmountAction(mwbp),
//             FocusParentIntent: FocusParentAction(mwbp),
//             ToggleFlexibleLockedStateIntent: ToggleFlexibleLockedStateAction(mwbp),
//             AddChildToFlexibleIntent: AddChildToFlexibleAction(mwbp),
//             SelectNextFlexibleIntent: SelectNextFlexibleAction(mwbp),
//           },
//           child: Focus(
//             onFocusChange: (_) {
//               var bn = mwbp.metaTree.branchNodes[params.id]! as FlexibleNode;
//               bn.handleFocusLoss();
//             },
//             focusNode: params.focusNode,
//             child: Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: BoxDecoration(border: Border.all(width: 2, color: flexibleSelectedColors[params.selectedState]!)),
//                 child: params.child.build(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

  @override
  String writeAsString() {
    return '''
    Flexible(
      flex: ${params.flex},
      child: ${params.child.writeAsString()},
    ); 
    ''';
  }
}

class MetaSizedBox extends MetaWidget {
  const MetaSizedBox();

  @override
  Widget build() {
    return const SizedBox();
  }
}

String newColumnId() {
  return "ColumnId_${uuid.v4().toString()}";
}

String newRowId() {
  return "RowId_${uuid.v4().toString()}";
}

///
