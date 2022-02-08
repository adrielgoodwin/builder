// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../models/field_data.dart';
import '../models/class_data.dart';
import '../extensions.dart';

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
