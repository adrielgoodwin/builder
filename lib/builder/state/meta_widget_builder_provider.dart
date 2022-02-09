// ignore_for_file: prefer_final_fields

import 'package:builder/builder/models/class_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../MetaWidgetTreeBuilder/meta_tree.dart';

class MetaWidgetBuilderProvider with ChangeNotifier {

  // /// Widget Builder
  // WidgetBuilderWithData _widgetBuilderWithData = WidgetBuilderWithData(
  //   nameOfWidget: 'NewWidget',
  //   topWidget: MetaFlexible(MetaFlexibleParams()),
  //   classesInUse: [],
  // );
  //
  // WidgetBuilderWithData get widgetBuilderWithData => _widgetBuilderWithData;
  //
  // void setNameOfWidget(String name) {
  //   _widgetBuilderWithData.nameOfWidget = name;
  //   notifyListeners();
  // }
  //
  // void setTopWidget(MetaWidget metaWidget) {
  //   _widgetBuilderWithData.topWidget = metaWidget;
  //   notifyListeners();
  // }
  //
  // void setClassInUse(ClassData classData) {
  //   _widgetBuilderWithData.classesInUse.add(classData);
  //   notifyListeners();
  // }

  // String get widgetAsString => _widgetBuilderWithData.writeAsString();
  //
  // String get widgetName => _widgetBuilderWithData.nameOfWidget;

  MetaTree metaTree = MetaTree();

  MetaTree get getMetaTree => metaTree;

  Widget get builtTree => _builtTree;

  Widget _builtTree = const SizedBox();

  void addUpdateBranches(List<BranchNode> branchNodes) {
    for(var bn in branchNodes) {
      var asFlexible = bn as FlexibleNode;
      print("Flexible: ${asFlexible.id} Flex: ${asFlexible.params.flex}");
      metaTree.addUpdateBranch(bn);
    }
    rebuildTree();
  }

  void addUpdateForks(List<ForkPoint> forks) {
    for(var fork in forks) {
      metaTree.addUpdateFork(fork);
    }
  }

  void addUpdateLeafs(List<Leaf> leafs) {
    for(var leaf in leafs) {
      metaTree.addUpdateLeaf(leaf);
    }
  }


  void rebuildTree() {
    _builtTree = metaTree.build().build();
    notifyListeners();
  }

  void setMetaTree(MetaTree newMetaTree) {
    metaTree = newMetaTree;
    rebuildTree();
  }

}
