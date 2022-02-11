import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Phone extends StatelessWidget {
  const Phone({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
    required this.pages,
    required this.tabItems,
    required this.pageController,
  }) : super(key: key);

  final ValueChanged<int> onSelectTab;
  final List<BottomNavigationBarItem> tabItems;
  final int currentTab;
  final List<Widget> pages;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    var allTabItems = tabItems.map((e) => e.label).toList().join(", ");
    // print(tabItems.length);
    /// In case the last tab is selected
    /// and one gets deleted
    /// this stops the out of bounds error
    var _currentTab = currentTab;
    if(currentTab + 1 > pages.length) {
      _currentTab = pages.length - 1;
    }
    // print("rebuilding Phone");
    return Material(
      elevation: 22,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentTab,
            items: tabItems,
            onTap: onSelectTab,
          ),
          body: PageView(
            controller: pageController,
            children: pages,
          ),
        ),
      ),
    );
  }
}
