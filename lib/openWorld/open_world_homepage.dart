import 'package:builder/openWorld/food_groups_app.dart';
import 'package:builder/openWorld/how_to_contribute.dart';
import 'package:builder/openWorld/what_is_food_groups.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class OpenWorldHomepage extends StatefulWidget {
  const OpenWorldHomepage({Key? key}) : super(key: key);

  @override
  State<OpenWorldHomepage> createState() => _OpenWorldHomepageState();
}

class _OpenWorldHomepageState extends State<OpenWorldHomepage> {

  PageController pageController = PageController();

  int currentIndex = 0;

  void animateTo(int page) {
    setState(() {
      currentIndex = page;
    });
    print(currentIndex);
    pageController.animateToPage(page, duration: const Duration(milliseconds: 777), curve: Curves.easeInOut);
  }

  Color color(int indexOfItem) => currentIndex == indexOfItem ? C.gold : Colors.purple;

  var key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Find out why
      bottomNavigationBar: BottomNavigationBar(
        key: key,
        onTap: (index) => animateTo(index),
        selectedItemColor: C.gold,
        items: const [
          BottomNavigationBarItem(
            label: "What is FoodGroups?",
            icon: Icon(Icons.book),
          ),
          BottomNavigationBarItem(
            label: "Try it",
            icon: Icon(Icons.food_bank),
          ),
          BottomNavigationBarItem(
            label: "How you can contribute",
            icon: Icon(Icons.handshake),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: const [
          WhatIsFoodGroups(),
          FoodGroupsApp(),
          HowToContribute(),
        ],
      ),
    );
  }
}
