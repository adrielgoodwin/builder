import '../models/metaWidget.dart';

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
  /// Get all the tips, or end widgets with no children
  var branchTips = metaTreeItems.values.where((element) => element.hasChild == false && element.hasChildren == false);

  /// make a list to hold onto the MetaWidgets who need consolidation
  List<MetaWidgetWithParent> consolidationList = [];

  /// here is my commited change in sentimental branch 1
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
    MetaWidgetWithParent metaWidgetWithParent = buildUp(metaTreeItems[tip.parentId]!, metaWidget,  metaTreeItems, metaWidgetParameters);
    print("MetaWidget parent id from tip buildUp: ${metaWidgetWithParent.parent.id}");

    /// This MetaWidgetWithParent is added to the consolidation list for further consolidation
    consolidationList.add(metaWidgetWithParent);
  }

  /// Consolidate all until the top widget is reached
  List<MetaWidgetWithParent> completedConsolidation = consolidate(consolidationList, [], metaTreeItems, metaWidgetParameters);

  /// Return that final widget
  return completedConsolidation[0].metaWidget;
}

List<MetaWidgetWithParent> consolidate(
    List<MetaWidgetWithParent> consolidationList,
    List<String> alreadyConsolidated,
    Map<String, MetaTreeItem> metaTreeItems,
    MetaWidgetParameters metaWidgetParameters,
    ) {
  print("ConsolidationList Length: ${consolidationList.length}");
  // print("\n Consolidation $consolidationCount \n");
  // consolidationCount += 1;

  /// instantiate list for new consolidations
  List<MetaWidgetWithParent> newConsolidationList = [];
  List<MetaWidgetWithParent> finished = [];

  /// for each item in the list we want to find the ones with no child branches.
  /// once found, we can merge their children
  for (MetaWidgetWithParent item in consolidationList) {
    print("ConsolidationList item parent id: ${item.parent.id}");

    /// get a list of all ids of the rows/columns
    Set<String> allIds = consolidationList.map((e) => e.parent.id).toSet();

    /// Right now, this will loop over every item in the list, look at the parent
    /// (the branch) see if its the bottom branch, then consolidate it.

    /// Because we are iterating over all the items, we could consolidate the same
    /// branch many times. Quick check to see if its been consolidated already.
    if (!alreadyConsolidated.contains(item.parent.id)) {
      /// intersection() returns the list of intersecting items in two sets.
      /// for example [1, 2, 3].intersection([2, 3, 4]) would return [2, 3]
      /// Here we check to see if any of the children branches of this current branch
      /// is then this branch has no children branches and we can consolidate it.
      if (allIds.intersection(item.parent.childrenBranches.toSet()).isEmpty) {
        /// get all meta widgets from the consolidation list where the parent is this item in question
        List<MetaWidget> allWidgets = consolidationList.where((element) => element.parent.id == item.parent.id).map((e) => e.metaWidget).toList();
        late MetaWidget consolidatedBranch;

        /// consolidate children
        var constructorKey = item.parent.metaWidgetEnum;
        if (constructorKey == MetaWidgets.row) {
          var rowParams = metaWidgetParameters.rowParams['base']!;
          rowParams.children = [...allWidgets];
          consolidatedBranch = metaWidgetMap[constructorKey]!(metaWidgetParameters.rowParams['base']);
        } else if (constructorKey == MetaWidgets.column) {
          var columnParams = metaWidgetParameters.columnParams['base']!;
          columnParams.children = [...allWidgets];
          consolidatedBranch = metaWidgetMap[constructorKey]!(metaWidgetParameters.columnParams['base']);
        }
        print("parent id is: ${item.parent.id}");

        /// When the top is reached
        finished = [MetaWidgetWithParent(buildUp(item.parent, item.metaWidget, metaTreeItems, metaWidgetParameters).metaWidget, metaTreeItems[item.parent.id]!)];

        if (consolidationList.length > 1) {
          MetaWidgetWithParent widgetBeforeNextBranch = buildUp(metaTreeItems[item.parent.parentId]!, consolidatedBranch, metaTreeItems, metaWidgetParameters);
          newConsolidationList.add(widgetBeforeNextBranch);
          alreadyConsolidated.add(item.parent.id);
        }

        /// This should stop duplicates from occurring
        /// Cant do this though, so lets switch to the other method of just looking at branches
        // consolidationList.removeWhere((element) => element.parent.id == item.parent.id);
      }
    }
  }
  if (consolidationList.length == 1) {
    return finished;
  }
  return consolidate(newConsolidationList, alreadyConsolidated, metaTreeItems, metaWidgetParameters);
}

MetaWidgetWithParent buildUp(MetaTreeItem parent, MetaWidget metaWidget, Map<String, MetaTreeItem> metaTreeItems, MetaWidgetParameters metaWidgetParameters) {
  /// Check if the parent is a branch, if so we do not build it we just return the MetaWidget
  if (!isBranch(parent)) {
    late MetaWidget biggerMetaWidget;

    print("building up");

    /// Get the key to construct the parent meta widget
    MetaWidgets constructorKey = parent.metaWidgetEnum;

    /// Check to see which type it is, get the appropriate parameters, and set the metaWidget
    if (constructorKey == MetaWidgets.flexible) {
      var flexParams = metaWidgetParameters.flexParams['base']!;
      flexParams.child = metaWidget;
      biggerMetaWidget = metaWidgetMap[constructorKey]!(flexParams);
    } else if (constructorKey == MetaWidgets.row) {
      biggerMetaWidget = metaWidgetMap[constructorKey]!(metaWidgetParameters.rowParams['base']);
    } else if (constructorKey == MetaWidgets.column) {
      biggerMetaWidget = metaWidgetMap[constructorKey]!(metaWidgetParameters.columnParams['base']);
    }
    String nextParentId = parent.parentId;

    /// Check if there is another parent.
    /// If not, we are at the top of the tree and we return
    if (nextParentId.isEmpty) {
      return MetaWidgetWithParent(metaWidget, parent);
    } else {
      return buildUp(metaTreeItems[nextParentId]!, biggerMetaWidget, metaTreeItems, metaWidgetParameters);
    }
  } else {
    return MetaWidgetWithParent(metaWidget, parent);
  }
}

bool isBranch(MetaTreeItem mti) {
  if (mti.metaWidgetEnum == MetaWidgets.column || mti.metaWidgetEnum == MetaWidgets.row) {
    if (mti.children.isEmpty) {
      false;
    }
    return true;
  }
  return false;
}
