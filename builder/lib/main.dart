import 'dart:convert';

import 'package:flutter/material.dart';
// Providers
import 'package:provider/provider.dart';
import 'builder/generated/providers/main_provider.dart';
import 'builder/state/global_input_provider.dart';
// import 'builder/state/classProvider.dart';
import 'builder/state/state.dart';
// screens
import 'builder/presentation/home_screen.dart';
// write files api
import 'builder/write_files_api.dart';
// models
import 'builder/models/registry.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  // sendReadRequest(Paths.registry).then((value) {
  //   if(value.isNotEmpty) {
  //     runApp(MyApp(Registry.fromJson(jsonDecode(value))));
  //   } else {
      runApp(MyApp(Registry()));
  //   windowManager.waitUntilReadyToShow().then((_) async{
  //     await windowManager.setAsFrameless();
  //     await windowManager.setFullScreen(true);
  // });
    // }
  // });
}

class MyApp extends StatefulWidget {
  MyApp(this.registry, {Key? key}) : super(key: key);

  Registry registry;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AllState()),
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