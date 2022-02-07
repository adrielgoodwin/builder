// ignore_for_file: prefer_final_fields

import 'package:builder/builder/models/class_data.dart';
import 'package:flutter/foundation.dart';
import '../models/metaWidget.dart';

class MetaWidgetBuilderProvider with ChangeNotifier {

  /// Widget Builder
  WidgetBuilderWithData _widgetBuilderWithData = WidgetBuilderWithData(
    nameOfWidget: 'NewWidget',
    topWidget: MetaFlexible(MetaFlexibleParams()),
    classesInUse: [],
  );

  WidgetBuilderWithData get widgetBuilderWithData => _widgetBuilderWithData;

  void setNameOfWidget(String name) {
    _widgetBuilderWithData.nameOfWidget = name;
    notifyListeners();
  }

  void setTopWidget(MetaWidget metaWidget) {
    _widgetBuilderWithData.topWidget = metaWidget;
    notifyListeners();
  }

  void setClassInUse(ClassData classData) {
    _widgetBuilderWithData.classesInUse.add(classData);
    notifyListeners();
  }

  String get widgetAsString => _widgetBuilderWithData.writeAsString();

  String get widgetName => _widgetBuilderWithData.nameOfWidget;

  // /// Tree Items
  // Map<String, MetaTreeItem> _metaTreeItems = {
  //   /// The top of the widget tree
  //   "TopFlex": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: '',
  //     childrenBranches: ['TopRow', 'Column1', 'Column2'],
  //     children: [''],
  //     id: 'TopFlex',
  //     metaWidgetEnum: MetaWidgets.flexible,
  //     hasChild: true,
  //     hasChildren: false,
  //   ),
  //
  //   /// The first child of the top flex
  //   "TopRow": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'TopFlex',
  //     children: [],
  //     childrenBranches: ['Column2', 'Column1'],
  //     id: 'TopRow',
  //     metaWidgetEnum: MetaWidgets.row,
  //     hasChild: false,
  //     hasChildren: true,
  //   ),
  //
  //   /// The first child of the Top row
  //   "TopRowFlex1": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'TopRow',
  //     childrenBranches: [],
  //     children: ['Column1'],
  //     id: 'TopRowFlex1',
  //     metaWidgetEnum: MetaWidgets.flexible,
  //     hasChild: true,
  //     hasChildren: false,
  //   ),
  //
  //   /// The second child of the top row
  //   "TopRowFlex2": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'TopRow',
  //     childrenBranches: [],
  //     children: ['Column2'],
  //     id: 'TopRowFlex2',
  //     metaWidgetEnum: MetaWidgets.flexible,
  //     hasChild: true,
  //     hasChildren: false,
  //   ),
  //   "Column1": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'TopRowFlex1',
  //     children: ["Text1"],
  //     childrenBranches: [],
  //     id: 'Column1',
  //     metaWidgetEnum: MetaWidgets.column,
  //     hasChild: false,
  //     hasChildren: true,
  //   ),
  //   "Column2": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'TopRowFlex2',
  //     children: ['Text2'],
  //     childrenBranches: [],
  //     id: 'Column2',
  //     metaWidgetEnum: MetaWidgets.column,
  //     hasChild: false,
  //     hasChildren: true,
  //   ),
  //   "Text2": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'Column2',
  //     childrenBranches: [],
  //     children: [],
  //     id: "Text2",
  //     metaWidgetEnum: MetaWidgets.text,
  //     hasChild: false,
  //     hasChildren: false,
  //   ),
  //   "Text1": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'Column1',
  //     childrenBranches: [],
  //     children: [],
  //     id: "Text1",
  //     metaWidgetEnum: MetaWidgets.text,
  //     hasChild: false,
  //     hasChildren: false,
  //   ),
  //   "Text13": MetaTreeItem(
  //     paramId: 'base',
  //     parentId: 'Column1',
  //     childrenBranches: [],
  //     children: [],
  //     id: "Text13",
  //     metaWidgetEnum: MetaWidgets.text,
  //     hasChild: false,
  //     hasChildren: false,
  //   ),
  // };
  //
  // void changeMTIParamId(MetaTreeItem mti, String newId) {
  //   _metaTreeItems[mti.id]!.paramId = newId;
  //   notifyListeners();
  // }
  //
  // Map<String, MetaTreeItem> get metaTreeItems => _metaTreeItems;
  //
  // void addMetaTreeItem(MetaTreeItem metaTreeItem) {
  //   _metaTreeItems[metaTreeItem.id] = metaTreeItem;
  //   notifyListeners();
  // }
  //
  // void removeMetaTreeItem(MTI metaTreeItem) {
  //   _metaTreeItems.remove(metaTreeItem.id);
  // }

  /// Meta Widget Parameters

  var _metaWidgetParameters = MetaWidgetParameters();

  MetaWidgetParameters get metaWidgetParameters => _metaWidgetParameters;

  void setFlexParams(String id, MetaFlexibleParams p) {
    _metaWidgetParameters.setFlexParams(id, p);
    notifyListeners();
  }

  void setTextParams(String id, MetaTextParams p) {
    _metaWidgetParameters.setTextParams(id, p);
    notifyListeners();
  }

  void setRowParams(String id, MetaRowParams p) {
    _metaWidgetParameters.setRowParams(id, p);
    notifyListeners();
  }

  void setColumnParams(String id, MetaColumnParams p) {
    _metaWidgetParameters.setColumnParams(id, p);
    notifyListeners();
  }



}
