import 'data_widget_relation.dart';
import 'tabItemData.dart';

class PageData {
  PageData({required this.pageWidgetName, required this.id, required this.tabItemData});

  final String id;
  final String pageWidgetName;
  final TabItemData tabItemData;
  List<String> classesInUse = [];
  List<DataWidgetRelation> usableWidgets = [
    DataWidgetRelation(className: 'User', listViewWidgets: [

    ], mediumViewWidgets: [], fullPageWidgets: []),
  ];
}
