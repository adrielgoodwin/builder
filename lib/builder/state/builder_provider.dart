import 'package:flutter/material.dart';
import '../models/tabItemData.dart';
import '../models/page_data.dart';
import 'package:uuid/uuid.dart';

import '../models/class_data.dart';
import '../models/registry.dart';

class BuilderProvider with ChangeNotifier {

  BuilderProvider({this.uuid = const Uuid(), required this.pages});

  factory BuilderProvider.instance({required Registry registry}) {
    return BuilderProvider(pages: [
      PageData(pageWidgetName: "page one", id: "id1", tabItemData: TabItemData(id: "id1", name: "Page one", icon: "icon"),),
      PageData(pageWidgetName: "page two", id: "id2", tabItemData: TabItemData(id: "id2", name: "Page two", icon: "icon"),),
      PageData(pageWidgetName: "page two", id: "id2", tabItemData: TabItemData(id: "id2", name: "Page two", icon: "icon"),),
    ]);
  }

  final Uuid uuid;

  String dirName = 'builder';



  /// Tabs

  void addPage(PageData page) {
    print("adding page, pageID: ${page.id} tabItemId: ${page.tabItemData.id}");
    pages = [...pages, page];
    notifyListeners();
  }

  void deletePage(String id) {
    if(pages.length >= 3) {
      pages.removeWhere((element) => element.id == id);
      notifyListeners();
    } else {
      print("You need at least two pages");
      /// this could be a little dialog box
    }
  }

  /// Pages
  List<PageData> pages;

  List<PageData> get getPages => pages;

}
