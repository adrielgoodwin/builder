import 'package:flutter/material.dart';
// Providers
import 'package:provider/provider.dart';
import 'builder/generated/providers/main_provider.dart';
import 'builder/state/class_maker_provider.dart';
import 'builder/state/focusProvider.dart';
// screens
import 'builder/presentation/home_screen.dart';
import 'package:oktoast/oktoast.dart';
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
        ChangeNotifierProvider.value(value: FocusProvider()),
      ],
      child: OKToast(
        textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
        backgroundColor: Colors.grey,
        radius: 10.0,
        animationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 3),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Builder',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: GestureDetector(child: const HomeScreen()),
        ),
      ),
    );
  }
}