// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../models/field_data.dart';

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

/// This class is for the consolidation process.
/// Once we build up to a branching point, we need to store
/// the MetaWidget at that point, along with its parent MetaTreeItem
class MetaWidgetWithParent {
  final MetaTreeItem parent;
  final MetaWidget metaWidget;

  MetaWidgetWithParent(this.metaWidget, this.parent);
}

/// This class is a container for our MetaWidget parameters.
/// When we add a MetaWidget into the 'tree' we will give it some
/// parameters, which we store here and associate with an id
class MetaWidgetParameters {
  Map<String, MetaFlexibleParams> flexParams = {
    'base': MetaFlexibleParams(),
    'id2': MetaFlexibleParams(),
  };

  Map<String, MetaTextParams> textParams = {
    'base': MetaTextParams(),
    'id2': MetaTextParams(),
  };

  Map<String, MetaRowParams> rowParams = {
    'base': MetaRowParams(),
  };

  Map<String, MetaColumnParams> columnParams = {
    'base': MetaColumnParams(),
  };

}

/// our first instantiation to be used
var mwp = MetaWidgetParameters();

/// Builder map
Map<MetaWidgets, Function> metaWidgetMap = {
  MetaWidgets.flexible: (MetaFlexibleParams flexParams) => MetaFlexible(flexParams),
  MetaWidgets.text: (MetaTextParams textParams) => MetaText(textParams),
  MetaWidgets.row: (MetaRowParams metaRowParams) => MetaRow(metaRowParams),
  MetaWidgets.column: (MetaColumnParams metaColumnParams) => MetaColumn(metaColumnParams),
};

/// Base MetaWidget class for extending all others
class MetaWidget {
  const MetaWidget();

  Widget build() => Row();
}

/// MetaTreeItem is a store for each MetaWidget data.
/// From this we are able to build up our tree with the
/// necessary data
class MetaTreeItem {
  MetaTreeItem({required this.parentId, required this.children, required this.id, required this.childrenBranches, required this.metaWidgetEnum, required this.hasChildren, required this.hasChild});

  final String id;
  final String parentId;
  final List<String> children;
  final MetaWidgets metaWidgetEnum;
  final List<String> childrenBranches;
  final bool hasChildren;
  final bool hasChild;
}


///
/// MetaWidgets that actually display something, final Widgets with no children
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

  String text = "oldText";

  void setText(String newText) {
    text = newText;
  }

  @override
  Widget build() {
    if (mtp.fieldData != null) {
      return GestureDetector(
        onTap: () => isSelected = !isSelected,
        child: Container(
          decoration: BoxDecoration(
            border: isSelected ? Border.all(color: Colors.teal) : Border.all(color: Colors.white30),
          ),
          child: Text(mtp.fieldData!.name, style: mtp.textStyle.build()),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {isSelected = !isSelected;
          text = "niceBoy";
        },
        child: Container(child: Text(text, style: mtp.textStyle.build()), decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.teal) : Border.all(color: Colors.white30),
        ),
        ),
      );
    }
  }

  String writeWidgetAtString() {
    return 'Text(\${${mtp.fieldData!.parentClass}.${mtp.fieldData!.name}}, style: ${mtp.textStyle.writeAsString()}';
  }
}

class MetaText2 extends MetaWidget {
  MetaText2({this.text = "Your Text Here", this.className = "", this.fieldName = "", this.textStyle = const MetaTextStyle()});

  String className;
  String fieldName;
  String text;
  MetaTextStyle textStyle;

  @override
  Widget build() {
    return Text(text, style: textStyle.build());
  }

  String writeWidgetAtString() {
    return 'Text($className.$fieldName, style: ';
  }
}


///
/// MetaWidgets that branch
///

class MetaRowParams {
  MetaRowParams({
    this.children = const [],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  List<MetaWidget> children;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
}

class MetaRow extends MetaWidget {
  MetaRow(this.mrp);

  final MetaRowParams mrp;

  @override
  Widget build() {
    return Row(
      children: mrp.children.map((e) => e.build()).toList(),
      mainAxisAlignment: mrp.mainAxisAlignment,
      crossAxisAlignment: mrp.crossAxisAlignment,
    );
  }
}

class MetaColumnParams {
  MetaColumnParams({
    this.children = const [],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  List<MetaWidget> children;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
}

class MetaColumn extends MetaWidget {
  MetaColumn(this.params);
  final MetaColumnParams params;

  @override
  Widget build() {
    return Column(
      children: params.children.map((e) => e.build()).toList(),
      mainAxisAlignment: params.mainAxisAlignment,
      crossAxisAlignment: params.crossAxisAlignment,
    );
  }
}


///
/// MetaWidgets that are containers
///

class MetaSizedBox extends MetaWidget {
  const MetaSizedBox();

  @override
  Widget build() {
    return const SizedBox();
  }
}

class MetaFlexibleParams {
  MetaFlexibleParams({this.flex = 1, this.child = const MetaSizedBox()});

  final int flex;
  MetaWidget child;
}

class MetaFlexible extends MetaWidget {
  MetaFlexible(this.mfp);

  MetaFlexibleParams mfp;

  @override
  Widget build() {
    return Flexible(
      flex: mfp.flex,
      child: mfp.child.build(),
    );
  }
}

///
