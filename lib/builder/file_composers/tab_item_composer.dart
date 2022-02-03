import '../models/tabItemData.dart';

String composeTabItem(List<TabItemData> tabItemData) {

  /// 1. get names for this line
  /// enum TabItem { *jobs, entries, account* }
  var enumValues = tabItemData.map((e) => e.name).toList().join(", ");

  /// 2. set allTabs map for each tabItemData
  var tabItemMap = tabItemData.map((e) {
    return '''    TabItem.${e.name}: TabItemData(
      key: Keys.${e.name}Tab,
      title: Strings.${e.name},
      icon: Icons.${e.icon},
    ),''';
  }).toList().join('\n');

  return '''import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/constants/keys.dart';
import 'package:starter_architecture_flutter_firebase/constants/strings.dart';

/// Make an enum to more clearly distinguish between tabs
enum TabItem { $enumValues }

/// This is a class to hold on to some static data about each tab item
class TabItemData {
  const TabItemData(
      {required this.key, required this.title, required this.icon});

  final String key;
  final String title;
  final IconData icon;

  /// A static map using the enums above as keys for tab item datas
  static const Map<TabItem, TabItemData> allTabs = {
    $tabItemMap
  };
}
  
  
  
 ''';

}