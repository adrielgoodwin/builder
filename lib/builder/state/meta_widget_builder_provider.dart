// ignore_for_file: prefer_final_fields

import 'package:builder/builder/models/class_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/metaWidget.dart';
import '../MetaWidgetTreeBuilder/meta_tree.dart';

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



  MetaTree metaTree = MetaTree();

  MetaTree get getMetaTree => metaTree;

  Widget get builtTree => _builtTree;

  Widget _builtTree = const SizedBox();

  void setMetaFork(ForkPoint forkPoint) {
    metaTree.addFork(forkPoint);
    rebuildTree();
  }

  void rebuildTree() {
    _builtTree = metaTree.build().build();
    notifyListeners();
  }

  void setMetaTree(MetaTree newMetaTree) {
    metaTree = newMetaTree;
    rebuildTree();
  }

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
