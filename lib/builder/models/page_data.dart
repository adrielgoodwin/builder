import 'tabItemData.dart';

// These are the navigate-able pages of the app
// Right now these pages contain a single child scroll view,
// populated by all the records of a particular class,
// wrapped up by their respective 'tile' widget.
// upon clicking, this will push on the stack the 'single record'
// page for that particular data model.

/// DOES NOT
/// contain any MetaWidgets that are user created.
/// USED TO GENERATE:
/// Router
/// App Pages

class PageData {
  PageData({required this.dataClass, required this.id, required this.tabItemData});

  final String id;
  final String dataClass;
  final TabItemData tabItemData;

}
