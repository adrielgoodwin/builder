import '../models/metaWidget.dart';
import 'package:uuid/uuid.dart';

/// Such sentiment
/// https://www.youtube.com/watch?v=gUUH8xzu41s&ab_channel=Vanilla

var uuid = const Uuid();

var metaTree = MetaTree();

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

  void addFork(ForkPoint newForkPoint) {
    forkPoints[newForkPoint.id] = newForkPoint;
  }

  void addBranch(BranchNode newBranchNode) {
    branchNodes[newBranchNode.id] = newBranchNode;
  }

  void addLeaf(Leaf newLeaf) {
    leafs[newLeaf.id] = newLeaf;
  }

   ///     \/     \/\     /\/     \\/     \\/\     /\
  ///-|    m e t a   w i d g e t    b u i l d i n g    |-]
   ///     /\     /\/     \/\     //\     //\/     /\

  MetaWidget build() {
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
  FlexibleNode({required String parentId, required String id, required String parentBranch, required this.params})
      : super(id: id, parentId: parentId, parentBranch: parentBranch);

  MetaFlexibleParams params;

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
