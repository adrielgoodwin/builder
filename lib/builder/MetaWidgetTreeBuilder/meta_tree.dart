import '../models/metaWidget.dart';
import 'package:uuid/uuid.dart';


/// to assemble tree:
/// 1. Build up all buildUp-ables
/// 2. Following the order of branch building,
///    consolidate and give to parent branch
/// 3. return final metaWidget for building

class MetaTree {

  Map<String, ForkPoint> forkPoints = {};

  Map<String, BranchNode> branchNodes = {};

  Map<String, Leaf> leafs = {};

  void buildLeafsUpwards() {
    for(var leaf in leafs.values) {
      forkPoints[leaf.parentBranch]!.children.add(buildUp(leaf.build(), par))
    }
  }

  MetaWidget buildUp(MetaWidget childNode, BranchNode parentNode) {
    parentNode.child = childNode;
    if(parentNode.parentBranch == parentNode.parentId) {
      return parentNode.build();
    } else {
      return buildUp(parentNode.build(), branchNodes[parentNode.parentId]!);
    }
  }

}

/// FORKS

class ForkPoint {

  ForkPoint({required this.id, required this.parentId, this.children = const []});

  final String id;
  final String parentId;
  List<MetaWidget> children;

  MetaWidget build() {
    return const MetaWidget();
  }

}

class RowFork extends ForkPoint {

  RowFork({required String parentId, required String id, required this.params, required List<MetaWidget> children}) : super(id: id, parentId: parentId, children: children);

  MetaRowParams params;

  @override build() {
    params.children = children;
    return MetaRow(params);
  }
}

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

  FlexibleNode({required String parentId, required String id, required String parentBranch, required this.params, required MetaWidget child}) : super(id: id, parentId: parentId, child: child, parentBranch: parentBranch);

  MetaFlexibleParams params;

  @override build() {
    params.child = child;
    return MetaFlexible(params);
  }
}

class Leaf {

  Leaf({required this.id, required this.parentBranch, this.parentId = ""});

  final String id;
  String parentId;
  final String parentBranch;

  MetaWidget build() {
    return const MetaWidget();
  }

}


var uuid = const Uuid();

class MTI {
  MTI({required this.id, required this.parentId});

  final String id;
  final String parentId;

  MetaWidget buildMW() {
    return const MetaWidget();
  }
}

List<String> branchIds = [];

Map<String, MTI> MTIs = {};

void addTextMTI(String parentId) {
  var y = TextMTI(id: "text_${uuid.v1().toString()}", parentId: parentId, params: MetaTextParams());
  MTIs[y.id] = y;
}

void addFlexibleMTI(String parentId) {
  var y = FlexibleMTI(parentId: parentId, params: MetaFlexibleParams(), id: "flexible_${uuid.v1().toString()}");
  MTIs[y.id] = y;
}

class MTINoChild extends MTI {

  MTINoChild({required String id, required String parentId}) : super(id: id, parentId: parentId);

}

class MTIWithChildren extends MTI {

  MTIWithChildren({required String id, required String parentId}) : super(id: id, parentId: parentId);

}

class MTIWithChild extends MTI {

  MTIWithChild({required String id, required String parentId}) : super(id: id, parentId: parentId);

}



class FlexibleMTI extends MTI {
  FlexibleMTI({required String parentId, required this.params, required String id}) : super(id: id, parentId: parentId);

  MetaFlexibleParams params;

  @override buildMW() {
    return MetaFlexible(params);
  }
}

class TextMTI extends MTI {
  TextMTI({required String parentId, required this.params, required String id}) : super (id: id, parentId: parentId);

  MetaTextParams params;

  @override
  MetaWidget buildMW() {
    return MetaText(params);
  }
}

var buildUpIteration = 1;

/// This function is for building up single child branches until it reaches a fork
MetaWidget buildUp(MTI parent, MetaWidget childMetaWidget) {

  print("Build up iteration: $buildUpIteration");
  buildUpIteration += 1;

  /// Check if the parent is a branch, if so we do not build it we just return the MetaWidget
  if (!branchIds.contains(parent.id)) {
    String nextParentId = parent.parentId;
    MetaWidget biggerMetaWidget =

    /// Check if there is another parent.
    /// If not, we have reached the very top of the tree and we return
    if (nextParentId.isEmpty) {
      return biggerMetaWidget;
    } else {
      return buildUp(MTIs[nextParentId]!, biggerMetaWidget);
    }
  } else {
    print("Build up reached a branch: ${parent.id}");
    return childMetaWidget;
  }
}
