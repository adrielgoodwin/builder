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
  ///-|    m e t a   w i d g e t    b u i l d i n g    |-]
   ///     /\     /\/     \/\     //\     //\/     /\

  void reset() {
    forkPoints.values.forEach((element) {element.children = [];});
  }

  MetaWidget build() {
    reset();
    buildLeafsUpwards();
    for (var forkKey in forkBuildOrder) {
      if(forkKey == forkBuildOrder[forkBuildOrder.length - 1]) {
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
}///  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0

///     ///
/// /// /// ///
///
///  f o r k s
///
/// /// /// ///

class ForkPoint {
  ForkPoint({required this.id, required this.parentId, required this.parentBranch, this.children = const []});

  final String id;
  final String parentId;
  final String parentBranch;
  List<MetaWidget> children;

  void addChild(MetaWidget newChild) => children = [...children, newChild];

  MetaWidget build() {
    return const MetaWidget();
  }
}

class RowFork extends ForkPoint {
  RowFork({required String parentId, required String id, required String parentBranch, required this.params})
      : super(id: id, parentId: parentId, parentBranch: parentBranch);

  MetaRowParams params;

  @override
  build() {
    params.children = children;
    return MetaRow(params);
  }
}

class ColumnFork extends ForkPoint {
  ColumnFork({required String parentId, required String id, required String parentBranch, required this.params})
      : super(id: id, parentId: parentId, parentBranch: parentBranch);

  MetaColumnParams params;

  @override
  build() {
    params.children = children;
    return MetaColumn(params);
  }
}


///  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0

/// /// /// /// /// ///
///    /   /   /   /
///  b r a n c h e s
///  /   /   /   /
/// /// /// /// /// ///

class BranchNode {
  BranchNode({required this.id, required this.parentId, required this.parentBranch, this.child = const MetaSizedBox()});

  final String id;
  final String parentId;
  final String parentBranch;
  MetaWidget child;

  MetaWidget build() {
    return const MetaWidget();
  }
}

class FlexibleNode extends BranchNode {
  FlexibleNode({required String parentId, this.flexibleSelectedState = FlexibleSelectedState.notSelected, required String id, required String parentBranch, required this.params})
      : super(id: id, parentId: parentId, parentBranch: parentBranch);

  MetaFlexibleParams params;
  FlexibleSelectedState flexibleSelectedState;

  @override
  build() {
    params.child = child;
    return MetaFlexible(params);
  }
} ///  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0

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
  TextLeaf({required String id, required String parentBranch, required String parentId, required  this.params}) : super(id: id, parentBranch: parentBranch, parentId: parentId);

  MetaTextParams params;

  MetaWidget build() {
    return MetaText(params);
  }

}


// ignore_for_file: constant_identifier_names, non_constant_identifier_names



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

// Make highlight enums and values for Columns

MetaTextParams mtp = MetaTextParams();

MetaText mt = MetaText(mtp);

MetaRowParams mrp = MetaRowParams(children: [mt]);

MetaRow mr = MetaRow(mrp);

MetaFlexibleParams mfp = MetaFlexibleParams(child: mr);

MetaWidget metaWidgetTest = MetaFlexible(mfp);

WidgetBuilderWithData wbwd = WidgetBuilderWithData(
  nameOfWidget: 'coolWidget',
  topWidget: metaWidgetTest,
  classesInUse: [ClassData(name: 'User', id: 'id', fieldData: [], neededImports: [])],
);

void main() {
  print(wbwd.writeAsString());
}

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

/// This class is a container for our MetaWidget parameters.
/// When we add a MetaWidget into the 'tree' we will give it some
/// parameters, which we store here and associate with an id
class MetaWidgetParameters {

  Map<String, MetaFlexibleParams> flexParams = {
    'base': MetaFlexibleParams(),
    'id2': MetaFlexibleParams(),
  };

  void setFlexParams(String id, MetaFlexibleParams p) => flexParams[id] = p;

  Map<String, MetaTextParams> textParams = {
    'base': MetaTextParams(),
    'id2': MetaTextParams(),
  };

  void setTextParams(String id, MetaTextParams p) => textParams[id] = p;

  Map<String, MetaRowParams> rowParams = {
    'base': MetaRowParams(),
  };

  void setRowParams(String id, MetaRowParams p) => rowParams[id] = p;

  Map<String, MetaColumnParams> columnParams = {
    'base': MetaColumnParams(),
  };

  void setColumnParams(String id, MetaColumnParams p) => columnParams[id] = p;

}

/// our first instantiation to be used
var mwp = MetaWidgetParameters();

/// Builder map
Map<MetaWidgets, Function> widgetBuilderMap = {
  MetaWidgets.flexible: (MetaFlexibleParams flexParams) => MetaFlexible(flexParams),
  MetaWidgets.text: (MetaTextParams textParams) => MetaText(textParams),
  MetaWidgets.row: (MetaRowParams metaRowParams) => MetaRow(metaRowParams),
  MetaWidgets.column: (MetaColumnParams metaColumnParams) => MetaColumn(metaColumnParams),
};

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
  MetaTextParams({this.fieldData, this.textStyle = const MetaTextStyle()});

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

enum RowSelectedState { selected, parentSelected, notSelected }

Map<RowSelectedState, Color> rowSelectedColors = {
  RowSelectedState.selected: Colors.green,
  RowSelectedState.parentSelected: Colors.blueAccent,
};

class MetaRowParams {
  MetaRowParams({
    this.children = const [],
    this.id = "defaultId",
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.selectedState = RowSelectedState.notSelected,
  });

  String id;
  List<MetaWidget> children;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  RowSelectedState selectedState;
}

class ChangeMainAxisAlignmentIntent extends Intent {
  const ChangeMainAxisAlignmentIntent(this.forkId, this.mainAxisAlignment);
  final MainAxisAlignment mainAxisAlignment;
  final String forkId;
}

class ChangeMainAxisAlignmentAction extends Action<ChangeMainAxisAlignmentIntent> {

  final MetaTree metaTree;
}

class MetaRow extends MetaWidget {
  MetaRow(this.mrp);

  final MetaRowParams mrp;

  @override
  Widget build() {
    return Container(
      decoration: BoxDecoration(border: Border.all(), color: rowSelectedColors[mfp.selectedState]),
      child: Row(
        children: mrp.children.map((e) => e.build()).toList(),
        mainAxisAlignment: mrp.mainAxisAlignment,
        crossAxisAlignment: mrp.crossAxisAlignment,
      ),
    );
  }

  @override
  String writeAsString() {
    List<String> children = mrp.children.map((e) => e.writeAsString()).toList();
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


enum ColumnSelectedState { selected, parentSelected, notSelected }

Map<ColumnSelectedState, Color> columnSelectedColors = {
  ColumnSelectedState.selected: Colors.green,
  ColumnSelectedState.parentSelected: Colors.blueAccent,
};

class MetaColumnParams {
  MetaColumnParams({
    this.children = const [],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.selectedState = ColumnSelectedState.notSelected
  });

  ColumnSelectedState selectedState;
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
      decoration: BoxDecoration(border: Border.all(), color: columnSelectedColors[mfp.selectedState]),
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
class MetaFlexibleParams {
  MetaFlexibleParams({this.flex = 1, this.id = "defaultId", this.selectedState = FlexibleSelectedState.notSelected, this.child = const MetaSizedBox()});

  FlexibleSelectedState selectedState;
  String id;
  final int flex;
  MetaWidget child;
}

enum FlexibleSelectedState { selected, siblingSelected, parentSelected, locked, notSelected }

Map<FlexibleSelectedState, Color> flexibleSelectedColors = {
  FlexibleSelectedState.selected: Colors.green,
  FlexibleSelectedState.siblingSelected: Colors.blueAccent,
  FlexibleSelectedState.parentSelected: Colors.blueAccent,
  FlexibleSelectedState.locked: Colors.yellow,
  FlexibleSelectedState.notSelected: Colors.white,
};

class MetaFlexible extends MetaWidget {
  MetaFlexible(this.mfp);

  MetaFlexibleParams mfp;

  @override
  Widget build() {
    return Container(
      decoration: BoxDecoration(border: Border.all(), color: flexibleSelectedColors[mfp.selectedState]),
      child: Flexible(
        flex: mfp.flex,
        child: mfp.child.build(),
      ),
    );
  }

  @override
  String writeAsString() {
    return '''
    Flexible(
      flex: ${mfp.flex},
      child: ${mfp.child.writeAsString()},
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

