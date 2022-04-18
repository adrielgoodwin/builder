import 'dart:async';

import 'package:flutter/material.dart';

/// Screens
import 'page_maker/page_maker_screen.dart';
import 'class_maker/class_maker_screen.dart';
import 'widget_maker/widget_maker_screen.dart';
import '/builder/colors/colors.dart';

// open world
import '../../openWorld/open_world_homepage.dart';

import 'package:provider/provider.dart';

import '../state/class_maker_provider.dart';

import '../generated/io_app/io_app_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();

  int currentIndex = 0;

  void animateTo(int page) {
    setState(() {
      currentIndex = page;
    });
    pageController.animateToPage(page, duration: const Duration(milliseconds: 777), curve: Curves.easeInOut);
  }
  List<String> titles = ["Page Maker", "Class Maker", "Widget Maker", "Builder Class Maker", "openWorld"];

  Color color(int indexOfItem) => currentIndex == indexOfItem ? C.gold : Colors.black87;

  bool saveHasStarted = false;
  
  Widget title(String title, int index) {
    return AnimatedOpacity(
      opacity: currentIndex == index ? 1 : 0,
      duration: const Duration(milliseconds: 333),
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {

    var rebuiltMessage = Provider.of<ClassMakerProvider>(context).rebuiltMessage;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app_outlined)),
        ],
        title: Stack(
          children: titles.asMap().entries.map((e) => title(e.value, e.key)).toList(),
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
                  IconButton(
                      onPressed: () {
                        animateTo(4);
                      },
                      icon: Icon(
                        Icons.star,
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
              children: [
                const PageMakerScreen(),
                const ClassMakerScreen(),
                const WidgetMakerScreen(),
                IoAppScreen(rebuiltMessage: rebuiltMessage),
                const OpenWorldHomepage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
