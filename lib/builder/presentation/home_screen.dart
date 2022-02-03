import 'dart:async';

import 'package:flutter/material.dart';

/// Screens
import 'page_maker/page_maker_screen.dart';
import 'class_maker/class_maker_screen.dart';
import 'widget_maker/widget_maker_screen.dart';
import '/builder/colors/colors.dart';

import 'package:provider/provider.dart';

import '../state/class_maker_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();

  int currentIndex = 0;
  List<String> titles = ["Page Maker", "Class Maker", "Widget Maker", "Builder Class Maker"];

  void animateTo(int page) {
    setState(() {
      currentIndex = page;
    });
    pageController.animateToPage(page, duration: const Duration(milliseconds: 777), curve: Curves.easeInOut);
  }

  Color color(int indexOfItem) => currentIndex == indexOfItem ? C.gold : Colors.black87;

  bool saveHasStarted = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.exit_to_app_outlined)),
        ],
        title: Stack(
          children: [
            AnimatedOpacity(
              opacity: currentIndex == 0 ? 1 : 0,
              duration: const Duration(milliseconds: 333),
              child: Text(titles[0]),
            ),
            AnimatedOpacity(
              opacity: currentIndex == 1 ? 1 : 0,
              duration: const Duration(milliseconds: 333),
              child: Text(titles[1]),
            ),
            AnimatedOpacity(
              opacity: currentIndex == 2 ? 1 : 0,
              duration: const Duration(milliseconds: 333),
              child: Text(titles[2]),
            ),
            AnimatedOpacity(
              opacity: currentIndex == 3 ? 1 : 0,
              duration: const Duration(milliseconds: 333),
              child: Text(titles[3]),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: double.infinity,
              width: 40,
              color: C.darkGray,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () => animateTo(0),
                      icon: Icon(
                        Icons.view_compact_outlined,
                        color: color(0),
                      )),
                  IconButton(
                      onPressed: () {
                        Provider.of<ClassMakerProvider>(context, listen: false).setIsClassForBuilder(false);
                        animateTo(1);
                      },
                      icon: Icon(
                        Icons.description,
                        color: color(1),
                      )),
                  IconButton(
                      onPressed: () => animateTo(2),
                      icon: Icon(
                        Icons.widgets_outlined,
                        color: color(2),
                      )),
                  IconButton(
                      onPressed: () {
                        Provider.of<ClassMakerProvider>(context, listen: false).setIsClassForBuilder(true);
                        animateTo(3);
                      },
                      icon: Icon(
                        Icons.medical_services_outlined,
                        color: color(3),
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 10,
            child: PageView(
              controller: pageController,
              children: const [
                PageMakerScreen(),
                ClassMakerScreen(),
                WidgetMakerScreen(),
                ClassMakerScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
