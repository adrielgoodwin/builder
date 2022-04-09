import 'registry.dart';
import 'page_data.dart';

/// Right now, classes are generated into the builder for use
/// At some point when the app is done all the files need
/// to be generated and placed into a the folder for the new app
/// 1. The classes
/// 2. The pages
/// 3. the widgets
/// 4. the routes
/// 5. tabItems

/// all of the data needed is stored in this app class below

class App {

  Registry classRegistry;
  List<PageData> pageDatas;

  App({required this.pageDatas, required this.classRegistry});

  void generateApp() {

  }

}