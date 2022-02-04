import '../models/metaWidget.dart';

/// explosion branch

// Step 1. build up to the most nearby fork
// Step 2. Put the metaWidget in the consolidation map
// Step 3. check if all siblings are built
// Step 4. if not, make a pass and repeat this process
// would need to store somewhere all of this
// build up returns a meta widget, so maybe a new map could work
// where the key is the parent id that the meta widget wants and the value is itself

// What we want to do next then is make 'passes'?
// We need each intersection to 'know' its parens that are intersections
// The pass is a check to see which intersection can be consolidated
// so the intersection checks to see if any of its descendant id's are themselves intersections

/// store all 'completed branches' In a Map, with their top id and complete MetaWidget

/// a function that will 'merge' the metaWidgets together into a tree
MetaWidget assembleTree(Map<String, MetaTreeItem> metaTreeItems, MetaWidgetParameters metaWidgetParameters) {

  print("\n Building tips:");

  /// Get all the tips, or end widgets with no children
  var branchTips = metaTreeItems.values.where((element) => element.hasChild == false && element.hasChildren == false);

  /// make a list to hold onto the MetaWidgets who need consolidation
  List<MetaWidgetWithParent> consolidationList = [];

  for(var tip in branchTips) {
    print("${tip.metaWidgetEnum.toString().split(".")[1]} widget id: ${tip.id}");
  }

  /// loop over tips to build up to nearest branch
  for (var tip in branchTips) {
    late MetaWidget metaWidget;

    /// Check to see which type it is, get the appropriate parameters, and set the metaWidget
    if (tip.metaWidgetEnum == MetaWidgets.flexible) {
      metaWidget = metaWidgetMap[tip.metaWidgetEnum]!(metaWidgetParameters.flexParams['base']);
    } else if (tip.metaWidgetEnum == MetaWidgets.text) {
      metaWidget = metaWidgetMap[tip.metaWidgetEnum]!(metaWidgetParameters.textParams['base']);
    }

    /// here, buildUp will put each child into their parent until a branch is reached.
    /// At that point it returns the latest MetaWidget, with its children consolidated,
    /// grouped with its parent MetaTreeItem (that's a branch)
    MetaWidgetWithParent metaWidgetWithParent = buildUp(metaTreeItems[tip.parentId]!, metaWidget, metaTreeItems, metaWidgetParameters);
    print("MetaWidget parent id from tip buildUp: ${metaWidgetWithParent.parent.id}");

    /// This MetaWidgetWithParent is added to the consolidation list for further consolidation
    consolidationList.add(metaWidgetWithParent);
  }

  print("Begin consolidation");

  /// Consolidate all until the top widget is reached
  List<MetaWidgetWithParent> completedConsolidation = consolidate(consolidationList, metaTreeItems, metaWidgetParameters);

  /// Return that final widget
  return completedConsolidation[0].metaWidget;
}

int consolidationPass = 1;

/// for each branch in the list we want to find the ones with no child branches.
/// once found, we can merge their children, make a new consolidation list and repeat.
/// When the list is done, we can just buildUp and return the top widget
List<MetaWidgetWithParent> consolidate(List<MetaWidgetWithParent> consolidationList, Map<String, MetaTreeItem> metaTreeItems, MetaWidgetParameters metaWidgetParameters) {
  /// instantiate list for new consolidations
  List<MetaWidgetWithParent> newConsolidationList = [];

  print("\n Consolidation pass: $consolidationPass");
  consolidationPass += 1;

  Set<String> allIds = consolidationList.map((e) => e.parent.id).toSet();

  print("Consolidation List: ${consolidationList.map((e) => e.parent.id).toList()}");
  /// Find the first buildable branch
  var buildableBranch = consolidationList.firstWhere((branch) => allIds.intersection(branch.parent.childrenBranches.toSet()).isEmpty);

  print("Branch Being Built: ${buildableBranch.parent.id}");

  /// get all meta widgets from the consolidation list where the parent is this branch in question
  List<MetaWidget> childrenOfBranch = consolidationList.where((element) => element.parent.id == buildableBranch.parent.id).map((e) => e.metaWidget).toList();

  /// build the branch with all its children
  MetaWidget consolidatedBranch = buildMultiChildMetaWidget(buildableBranch.parent, childrenOfBranch, metaWidgetParameters);
  print(consolidatedBranch);
  MetaWidgetWithParent widgetBeforeNextBranch = buildUp(metaTreeItems[buildableBranch.parent.parentId]!, consolidatedBranch, metaTreeItems, metaWidgetParameters);
  consolidationList.removeWhere((element) => element.parent.id == buildableBranch.parent.id);
  print("consolidation list after removals: ${consolidationList.length}");
  if (consolidationList.isEmpty) {
    print("Empty consolidation list, building up ${widgetBeforeNextBranch.parent.id}");
    return [buildUp(metaTreeItems[buildableBranch.parent.parentId]!, consolidatedBranch, metaTreeItems, metaWidgetParameters)];
  } else {
    newConsolidationList = [...consolidationList, widgetBeforeNextBranch];
    print("consolidation list after removals before return: ${newConsolidationList.length}");
    return consolidate(newConsolidationList, metaTreeItems, metaWidgetParameters);
  }
}

MetaWidget buildMultiChildMetaWidget(MetaTreeItem parent, List<MetaWidget> children, MetaWidgetParameters metaWidgetParameters) {
  var constructorKey = parent.metaWidgetEnum;
  late MetaWidget consolidatedBranch;
  if (constructorKey == MetaWidgets.row) {
    var rowParams = metaWidgetParameters.rowParams['base']!;
    rowParams.children = children;
    consolidatedBranch = metaWidgetMap[constructorKey]!(rowParams);

  } else if (constructorKey == MetaWidgets.column) {
    var columnParams = metaWidgetParameters.columnParams['base']!;
    columnParams.children = children;
    consolidatedBranch = metaWidgetMap[constructorKey]!(columnParams);

  }
  return consolidatedBranch;
}

int buildUpIteration = 0;

int flexesBuilt = 0;

/// This function is for building up single child branches until it reaches a fork
MetaWidgetWithParent buildUp(MetaTreeItem parent, MetaWidget childMetaWidget, Map<String, MetaTreeItem> metaTreeItems, MetaWidgetParameters metaWidgetParameters) {

  print("Build up iteration: $buildUpIteration");
  buildUpIteration += 1;

  /// Check if the parent is a branch, if so we do not build it we just return the MetaWidget
  if (!isBranch(parent)) {
    String nextParentId = parent.parentId;
    MetaWidget biggerMetaWidget = buildSingleChildMetaWidget(parent, childMetaWidget, metaWidgetParameters);

    /// Check if there is another parent.
    /// If not, we have reached the very top of the tree and we return
    if (nextParentId.isEmpty) {
      return MetaWidgetWithParent(biggerMetaWidget, parent);
    } else {
      return buildUp(metaTreeItems[nextParentId]!, biggerMetaWidget, metaTreeItems, metaWidgetParameters);
    }
  } else {
    print("Build up reached a branch: ${parent.id}");
    return MetaWidgetWithParent(childMetaWidget, parent);
  }
}

MetaWidget buildSingleChildMetaWidget(MetaTreeItem parentTreeItem, MetaWidget childMetaWidget, MetaWidgetParameters metaWidgetParameters) {
  late MetaWidget singleChildMetaWidget;

  /// Get the key to construct the parent meta widget
  MetaWidgets constructorKey = parentTreeItem.metaWidgetEnum;
  print("Building single child meta widget: ${constructorKey.toString()}");
  if (constructorKey == MetaWidgets.flexible) {
    print("Flexes built: $flexesBuilt");
    flexesBuilt += 1;
    var flexParams = metaWidgetParameters.flexParams['base']!;
    flexParams.child = childMetaWidget;
    flexParams.id = parentTreeItem.id;
    singleChildMetaWidget = metaWidgetMap[constructorKey]!(flexParams);
  }

  return singleChildMetaWidget;
}

/// check if MetaTreeItem is a branch
bool isBranch(MetaTreeItem mti) => mti.metaWidgetEnum == MetaWidgets.column || mti.metaWidgetEnum == MetaWidgets.row ? true : false;
