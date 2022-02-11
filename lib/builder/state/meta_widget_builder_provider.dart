// ignore_for_file: prefer_final_fields

import 'package:builder/builder/models/class_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../MetaWidgetTreeBuilder/meta_tree.dart';

class MetaWidgetBuilderProvider with ChangeNotifier {

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
    rebuildTree();
  }

  void addUpdateLeafs(List<Leaf> leafs) {
    for(var leaf in leafs) {
      metaTree.addUpdateLeaf(leaf);
    }
    rebuildTree();
  }

  void deleteForks(List<ForkPoint> forks) {
    for (var fork in forks) {
      metaTree.forkPoints.remove(fork.id);
    }
    rebuildTree();
  }

  void deleteBranches(List<BranchNode> branches) {
    for (var branch in branches) {
      metaTree.branchNodes.remove(branch.id);
    }
    rebuildTree();
  }

  void deleteLeafs(List<Leaf> leafList) {
    for(var leaf in leafList) {
      metaTree.leafs.remove(leaf.id);
    }
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

}
