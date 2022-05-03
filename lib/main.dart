import 'package:flutter/material.dart';
// Providers
import 'builder/generated/providers/main_provider.dart';
import 'builder/state/class_maker_provider.dart';
import 'package:provider/provider.dart';
// screens
import 'builder/presentation/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ClassMakerProvider()),
        ChangeNotifierProvider.value(value: MainProvider()),
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