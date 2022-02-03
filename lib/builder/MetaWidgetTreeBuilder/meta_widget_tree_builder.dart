import '../models/metaWidget.dart';

List<MetaWidgetWithParent> consolidate(List<MetaWidgetWithParent> consolidationList) {
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
        finished = [MetaWidgetWithParent(buildUp(item.parent, item.metaWidget).metaWidget, metaTreeItems[item.parent.id]!)];

        if (consolidationList.length > 1) {
          MetaWidgetWithParent widgetBeforeNextBranch = buildUp(metaTreeItems[item.parent.parentId]!, consolidatedBranch);
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
  return consolidate(newConsolidationList);
}

MetaWidgetWithParent buildUp(MetaTreeItem parent, MetaWidget metaWidget) {
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
      return buildUp(metaTreeItems[nextParentId]!, biggerMetaWidget);
    }
  } else {
    return MetaWidgetWithParent(metaWidget, parent);
  }
}