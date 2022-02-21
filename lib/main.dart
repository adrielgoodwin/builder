import 'package:flutter/material.dart';
import 'builder/presentation/home_screen.dart';
import 'package:provider/provider.dart';
import 'builder/state/builder_provider.dart';
import 'builder/state/functions_provider.dart';
import 'builder/state/class_maker_provider.dart';
import 'builder/state/meta_widget_builder_provider.dart';
import 'package:uuid/uuid.dart';
import 'builder/write_files_api.dart';

// every one of these lines of code is a file, providing us with entire sets of code to be referenced here
// in our own code :) This alone gives us so much power. The power of modularity, the power of dexterity,
// the power of re-usability, and sharing.

// right here whats imported is some classes we use to easily store the data we would like to use in our application
// We know the computer runs on simple commands so the classes act as a way to speak clearly and efficiently to store
// and retrieve the types of data we need.

/// models
import 'builder/models/class_data.dart';
import 'builder/models/field_data.dart';
import 'builder/models/registry.dart';

import 'builder/models/tabItemData.dart';
import 'builder/models/page_data.dart';
import 'builder/MetaWidgetTreeBuilder/meta_tree.dart';
import 'builder/models/metaWidget.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

void main() {

  var uuid = Uuid();

  var id1 = uuid.v4();
  var id2 = uuid.v4();

  var pages = [
    PageData(pageWidgetName: "page one", id: id1, tabItemData: TabItemData(id: id1, name: "Page one", icon: "icon"),),
    PageData(pageWidgetName: "page two", id: id2, tabItemData: TabItemData(id: id2, name: "Page two", icon: "icon"),),
  ];

  // testRequest();

  runApp(MyApp());

}

// Future testRequest() async {
//   Map<String, String> writeRequest = {
//     'path': 'lib/builder/data_classes/',
//     'name': 'test.dart',
//     'code': '// just a test baby'
//   };
//   sendWriteRequest(writeRequest).then((value) => print(value));
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Registry registry = Registry(appName: 'app', registeredClasses: []);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BuilderProvider.instance(registry: registry)),
        ChangeNotifierProvider.value(value: FunctionsProvider()),
        ChangeNotifierProvider.value(value: ClassMakerProvider()),
        ChangeNotifierProvider.value(value: MetaWidgetBuilderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Builder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}