import 'package:builder/builder/state/meta_widget_builder_provider.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../models/field_data.dart';
import '../models/class_data.dart';
import '../extensions.dart';

/// Such sentiment
/// https://www.youtube.com/watch?v=gUUH8xzu41s&ab_channel=Vanilla

var uuid = const Uuid();

class MetaTree {
  Map<String, ForkPoint> forkPoints = {};

  Map<String, BranchNode> branchNodes = {};

  Map<String, Leaf> leafs = {};

  List<String> forkBuildOrder = [];

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
  ///-|    m e t a    t r e e    g e t t e r s    |-]
  ///     /\     /\/     \/\     //\     //\/     /\

  Map<String, BranchNode> getSiblingBranches(String id) {
    var parentId = branchNodes[id]!.parentId;
    Map<String, BranchNode> siblings = {};
    branchNodes.values.where((y) => y.parentId == parentId).toList().forEach((y) => siblings[y.id] = y);
    return siblings;
  }

  ///     \/     \/\     /\/     \\/     \\/\     /\
  ///-|    m e t a   w i d g e t    b u i l d i n g    |-]
  ///     /\     /\/     \/\     //\     //\/     /\

  void reset() {
    forkPoints.values.forEach((element) {
      element.children = [];
    });
  }

  MetaWidget build() {
    reset();
    buildLeafsUpwards();
    for (var forkKey in forkBuildOrder) {
      if (forkKey == forkBuildOrder[forkBuildOrder.length - 1]) {
        print("isTop, forkKey: $forkKey");
        buildForkAndBeyond(forkKey, true);
      } else {
        buildForkAndBeyond(forkKey, false);
      }
    }
    return topMetaWidget;
  }

  MetaWidget buildUp(MetaWidget childNode, BranchNode parentNode) {
    parentNode.child = childNode;
    if (parentNode.parentBranch == parentNode.parentId) {
      return parentNode.build();
    }
    if (parentNode.parentId.isNotEmpty) {
      return buildUp(parentNode.build(), branchNodes[parentNode.parentId]!);
    }
    return parentNode.build();
  }

  void buildLeafsUpwards() {
    int counter = 0;
    for (var leaf in leafs.values) {
      counter += 1;
      print("amount of leafs: $counter");
      forkPoints[leaf.parentBranch]!.addChild(buildUp(leaf.build(), branchNodes[leaf.parentId]!));
    }
  }

  void buildForkAndBeyond(String forkKey, bool isTop) {
    if (!isTop) {
      forkPoints[forkPoints[forkKey]!.parentBranch]!.addChild(buildUp(forkPoints[forkKey]!.build(), branchNodes[forkPoints[forkKey]!.parentId]!));
    } else {
      topMetaWidget = buildUp(forkPoints[forkKey]!.build(), branchNodes[forkPoints[forkKey]!.parentId]!);
    }
  }
}

///  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0

///     ///
/// /// /// ///
///
///  f o r k s
///
/// /// /// ///

class ForkPoint {
  ForkPoint({required this.id, required this.focusNode, required this.parentId, required this.mwbp, required this.parentBranch, this.children = const []});

  final String id;
  final String parentId;
  final String parentBranch;
  final FocusNode focusNode;
  List<MetaWidget> children;
  MetaWidgetBuilderProvider mwbp;

  void addChild(MetaWidget newChild) => children = [...children, newChild];

  MetaWidget build() {
    return const MetaWidget();
  }

  void addChildFlexible() {
    var newFocusNode = FocusNode();
    var newId = "flexible_${uuid.v4().toString()}";
    var newFlexible = FlexibleNode(focusNode: newFocusNode, mwbp: mwbp, parentId: id, parentBranch: "", id: newId, params: MetaFlexibleParams(id: newId, focusNode: newFocusNode));
    mwbp.metaTree.branchNodes[newId] = newFlexible;
    mwbp.rebuildTree();
  }

  void requestFocus() {}

  void setSelectedStateAsParent() {}

}

class RowFork extends ForkPoint {
  RowFork({required String parentId, required FocusNode focusNode, required MetaWidgetBuilderProvider mwbp, required String id, required String parentBranch, required this.params})
      : super(id: id, parentId: parentId, mwbp: mwbp, focusNode: focusNode, parentBranch: parentBranch);

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

  @override
  void setSelectedStateAsParent() {
    params.selectedState = RowSelectedState.childrenSelected;
    mwbp.rebuildTree();
  }

}

class ColumnFork extends ForkPoint {
  ColumnFork({required String parentId, required FocusNode focusNode, required MetaWidgetBuilderProvider mwbp, required String id, required String parentBranch, required this.params})
      : super(id: id, parentId: parentId, focusNode: focusNode, mwbp: mwbp, parentBranch: parentBranch);

  MetaColumnParams params;

  @override
  build() {
    params.children = children;
    return MetaColumn(params);
  }

  @override
  void requestFocus() {
    params.selectedState = ColumnSelectedState.selected;
    focusNode.requestFocus();
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
  BranchNode({required this.id, required this.mwbp, required this.focusNode, required this.parentId, required this.parentBranch, this.child = const MetaSizedBox()});

  final String id;
  final String parentId;
  final String parentBranch;
  final FocusNode focusNode;
  MetaWidget child;
  final MetaWidgetBuilderProvider mwbp;

  MetaWidget build() {
    return const MetaWidget();
  }

  void requestFocus() {}

  void addTextChild() {
    var textId = "Text_${uuid.v4().toString()}";
    var textLeaf = TextLeaf(id: textId, parentBranch: parentBranch, parentId: id, params: MetaTextParams(id: textId));
    mwbp.addUpdateLeafs([textLeaf]);
  }

}

class FlexibleNode extends BranchNode {
  FlexibleNode({
    required String parentId,
    required FocusNode focusNode,
    required MetaWidgetBuilderProvider mwbp,
    this.flexibleSelectedState = FlexibleSelectedState.notSelected,
    required String id,
    required String parentBranch,
    required this.params,
  }) : super(id: id, parentId: parentId, focusNode: focusNode, mwbp: mwbp, parentBranch: parentBranch);

  MetaFlexibleParams params;
  FlexibleSelectedState flexibleSelectedState;

  @override
  build() {
    params.child = child;
    return MetaFlexible(params, mwbp);
  }

  @override
  void requestFocus() {
    mwbp.metaTree.forkPoints[parentId]!.setSelectedStateAsParent();
    params.selectedState = FlexibleSelectedState.selected;
    focusNode.requestFocus();
    mwbp.rebuildTree();
  }

  void setSelectedState(FlexibleSelectedState newState) {
    params.selectedState = newState;
    mwbp.rebuildTree();
  }

  void toggleLockedState() {
    if(params.selectedState == FlexibleSelectedState.selected) {
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
  Leaf({required this.id, required this.parentBranch, this.parentId = ""});

  final String id;
  String parentId;
  final String parentBranch;

  MetaWidget build() {
    return const MetaWidget();
  }
}

class TextLeaf extends Leaf {
  TextLeaf({required String id, required String parentBranch, required String parentId, required this.params}) : super(id: id, parentBranch: parentBranch, parentId: parentId);

  MetaTextParams params;

  MetaWidget build() {
    return MetaText(params);
  }
}

enum MetaWidgets { row, column, flexible, singleChildScroll, text, container, wrap, visibility }

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

  Widget build() => Row();

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
  const MetaTextStyle({this.fontSize = 12});

  final double fontSize;

  TextStyle build() {
    return TextStyle(fontSize: fontSize);
  }

  String writeAsString() {
    return 'TextStyle(fontSize: $fontSize)';
  }
}

class MetaTextParams {
  MetaTextParams({required this.id, this.fieldData, this.textStyle = const MetaTextStyle()});

  final String id;
  FieldData? fieldData;
  MetaTextStyle textStyle;
}

class MetaText extends MetaWidget {
  MetaText(this.mtp);

  bool isSelected = false;

  final MetaTextParams mtp;

  @override
  Widget build() {
    if (mtp.fieldData != null) {
      return Text(mtp.fieldData!.name, style: mtp.textStyle.build());
    } else {
      return Text("A text field", style: mtp.textStyle.build());
    }
  }

  @override
  String writeAsString() {
    if (mtp.fieldData != null) {
      return 'Text(\${${mtp.fieldData!.parentClass}.${mtp.fieldData!.name}}, style: ${mtp.textStyle.writeAsString()}';
    } else {
      return 'Text("TextWidget", style: ${mtp.textStyle.writeAsString()}';
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
    print("Row Params: SelectedState: ${params.selectedState}");
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
  MetaColumn(this.params);

  final MetaColumnParams params;

  @override
  Widget build() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1, color: columnSelectedColors[params.selectedState]!)),
      child: Column(
        children: params.children.map((e) => e.build()).toList(),
        mainAxisAlignment: params.mainAxisAlignment,
        crossAxisAlignment: params.crossAxisAlignment,
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
  FlexibleSelectedState.siblingSelected: Colors.blueAccent,
  FlexibleSelectedState.parentSelected: Colors.blueAccent,
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
    print("keypressed");
    Map<String, FlexibleNode> flexibles = mwbp.metaTree.getSiblingBranches(intent.flexibleId).map((key, value) => MapEntry(key, value as FlexibleNode));
    flexibles.removeWhere((key, y) => y.flexibleSelectedState == FlexibleSelectedState.locked);
    var i = flexibles.values.length - 1;
    flexibles[intent.flexibleId]!.params.flex = flexibles[intent.flexibleId]!.params.flex + i;
    for (var sibling in flexibles.values) {
      if (sibling.id != intent.flexibleId) {
        sibling.params.flex = sibling.params.flex - 1;
        flexibles[sibling.id] = sibling;
      }
    }
    mwbp.addUpdateBranches(flexibles.values.toList());
  }
}

class DecreaseFlexibleAmountAction extends Action<DecreaseFlexibleAmountIntent> {
  DecreaseFlexibleAmountAction(this.mwbp);

  final MetaWidgetBuilderProvider mwbp;

  @override
  void invoke(DecreaseFlexibleAmountIntent intent) {
    print("keypressed");
    Map<String, FlexibleNode> flexibles = mwbp.metaTree.getSiblingBranches(intent.flexibleId).map((key, value) => MapEntry(key, value as FlexibleNode));
    flexibles.removeWhere((key, y) => y.flexibleSelectedState == FlexibleSelectedState.locked);
    var i = flexibles.values.length - 1;
    flexibles[intent.flexibleId]!.params.flex = flexibles[intent.flexibleId]!.params.flex - i;
    for (var sibling in flexibles.values) {
      if (sibling.id != intent.flexibleId) {
        sibling.params.flex = sibling.params.flex + 1;
        flexibles[sibling.id] = sibling;
      }
    }
    mwbp.addUpdateBranches(flexibles.values.toList());
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
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.arrowUp): IncreaseFlexibleAmountIntent(params.id),
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.arrowDown): DecreaseFlexibleAmountIntent(params.id),
          LogicalKeySet(LogicalKeyboardKey.space): FocusParentIntent(mwbp.metaTree.branchNodes[params.id]!.parentId),
          LogicalKeySet(LogicalKeyboardKey.keyL): ToggleFlexibleLockedStateIntent(params.id),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            IncreaseFlexibleAmountIntent: IncreaseFlexibleAmountAction(mwbp),
            DecreaseFlexibleAmountIntent: DecreaseFlexibleAmountAction(mwbp),
            FocusParentIntent: FocusParentAction(mwbp),
            ToggleFlexibleLockedStateIntent: ToggleFlexibleLockedStateAction(mwbp),
          },
          child: Focus(
            focusNode: params.focusNode,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(border: Border.all(width: 1, color: flexibleSelectedColors[params.selectedState]!)),
              child: params.child.build(),
            ),
          ),
        ),
      ),
    );
  }

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

///
