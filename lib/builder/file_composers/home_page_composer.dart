import '../models/page_data.dart';

/// Functions: Linking Tab Items to pages
/// Passing these tabs with their data into a CupertinoScaffold
/// Passing in also the Route changing function

/// Required data:
/// TabItems and associated pages


String composeHomePage(List<PageData> pageDatas) {

  String imports = pageDatas.map((e) => "import 'pages/${e.dataClass}.dart';").toList().join("\n");

  String navigatorKeys = pageDatas.map((e) => "    TabItem.${e.tabItemData.name}: GlobalKey<NavigatorState>(),").toList().join("\n");

  String widgetBuilders = pageDatas.map((e) => "    TabItem.${e.tabItemData.name}: (_) => ${e.dataClass}Page(),").toList().join("\n");

  return '''import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/home/cupertino_home_scaffold.dart';
import 'package:starter_architecture_flutter_firebase/app/home/tab_item.dart';
$imports

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.${pageDatas[0].tabItemData.name};

  /// A map of global keys using the same Enum from tab item
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
$navigatorKeys
  };
  
  /// a map of WidgetBuilder using the same Enum from tab item.
  /// Each enum here is mapped to a page :)
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
$widgetBuilders
    };
  }

  /// this is for setting the state of _currentTab, which will call a rebuild
  /// because _currentTab is used as a parameter within the build function.
  /// This function gets passed into the CupertinoHomeScaffold so its actually
  /// accessed from inside this widget.
  /// This is a good example of a simple callback being used
  void _select(TabItem tabItem) {
    /// we check to see if we are already somewhere in/on the selected tab
    if (tabItem == _currentTab) {
      /// then pop to first route... so I guess any route can have sub-routes?
      // pop to first route
      navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
    } else {
      /// otherwise set _currentTab = the new tabItem
      setState(() => _currentTab = tabItem);
    }
  }

  /// values calling rebuild: _currentTab
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !(await navigatorKeys[_currentTab]!.currentState?.maybePop() ??
              false),
      /// CupertinoHomeScaffold is the place where the navigation tabs are set
      child: CupertinoHomeScaffold(
        /// rebuild when this value is changed from the _select function
        currentTab: _currentTab,
        /// the function to change the tab, does not change
        onSelectTab: _select,
        /// builders for each page, also does not change
        widgetBuilders: widgetBuilders,
        /// keys used for navigation, will not change.
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
''';

}