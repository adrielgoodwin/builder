
String composeHomeScaffold(List<String> tabItemNames) {

  var items = "";

  for (var e in tabItemNames) {
    items += "          _buildItem(TabItem.$e), \n";
  }

  return '''

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/home/tab_item.dart';
import 'package:starter_architecture_flutter_firebase/constants/keys.dart';
import 'package:starter_architecture_flutter_firebase/routing/cupertino_tab_view_router.dart';

@immutable
class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
    required this.widgetBuilders,
    required this.navigatorKeys,
  }) : super(key: key);

  /// currentTab gets set in parent state by calling onSelectTab
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      /// Tab bar to switch between tabs
      tabBar: CupertinoTabBar(
        key: const Key(Keys.tabBar),
        currentIndex: currentTab.index,
        /// tab bar 'items' or buttons
        items: [
          // 1. one line here
          $items
        ],
        /// gives the index of the tapped tab
        /// calls onSelectTab, passing the TabItem from the given index
        onTap: (index) => onSelectTab(TabItem.values[index]),
        activeColor: Colors.indigo,
      ),
      tabBuilder: (context, index) {
        /// grab the TabItem for the current index
        /// i suppose the order of the TabItems in the enum
        /// declaration is the same as the order here
        final item = TabItem.values[index];
        return CupertinoTabView(
          /// use that TabItem to select the appropriate key
          navigatorKey: navigatorKeys[item],
          /// build the page for the current tab
          builder: (context) => widgetBuilders[item]!(context),
          /// TODO: learn about routes
          onGenerateRoute: CupertinoTabViewRouter.generateRoute,
        );
      },
    );
  }

  /// Notice that the name of this function is kind of ambiguous
  /// but it doesn't really matter because the file is small enough
  /// and it seems to just make sense upon a little reading
  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    /// selects itemData from static map in tab_item.dart
    final itemData = TabItemData.allTabs[tabItem]!;
    /// created a navbar item with the data
    return BottomNavigationBarItem(
      icon: Icon(itemData.icon),
      label: itemData.title,
    );
  }
}  
  
''';

}