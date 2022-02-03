// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:builder/builder/presentation/page_maker/phone.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/builder_provider.dart';
import '../../state/functions_provider.dart';
import '../../models/page_data.dart';
import 'functions.dart';

class PageMakerScreen extends StatefulWidget {
  const PageMakerScreen({Key? key}) : super(key: key);

  @override
  _PageMakerScreenState createState() => _PageMakerScreenState();
}

class _PageMakerScreenState extends State<PageMakerScreen> {
  var _currentTab = 0;

  PageController pageController = PageController();

  var screenSizes = [
    ScreenSize(widthInMM: 65, heightInMM: 126, name: "Little Phone"),
    ScreenSize(widthInMM: 72.7, heightInMM: 148.9, name: "Regular Phone"),
    ScreenSize(widthInMM: 88.1, heightInMM: 162.8, name: "Big Phone"),
    ScreenSize(widthInMM: 180, heightInMM: 130, name: "Little Tablet"),
    ScreenSize(widthInMM: 210, heightInMM: 150, name: "Regular Tablet"),
    ScreenSize(widthInMM: 225, heightInMM: 180, name: "Big Tablet"),
  ];

  var screenSize = ScreenSize(widthInMM: 65, heightInMM: 126, name: "Little Phone");

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<BuilderProvider>(context);
    var functionsState = Provider.of<FunctionsProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Classes",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ...functions(state, functionsState),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                // alignment: Alignment.center,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: screenSize.widthInPx,
                        height: screenSize.heightInPx,
                        child: Phone(
                            currentTab: _currentTab,
                            onSelectTab: (index) => setState(() {
                                  _currentTab = index;
                                  pageController.animateToPage(index, duration: Duration(milliseconds: 333), curve: Curves.easeInOut);
                                }),
                            pageController: pageController,
                            pages: state.getPages.map((e) => Page(e)).toList(),
                            tabItems: state.getPages.map((e) => BottomNavigationBarItem(icon: Icon(Icons.face), label: e.name)).toList()),
                      ),
                    ),
                    Positioned(child: sizeSelector(),
                    right: 0,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sizeSelector() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        ...screenSizes.sublist(0, 3).map((screenSize) => screenSizeTile(screenSize)).toList(),
        SizedBox(
          height: 12,
        ),
        ...screenSizes.sublist(3, 6).map((screenSize) => screenSizeTile(screenSize)).toList(),
      ],
    );
  }

  Widget screenSizeTile(ScreenSize screenSizeData) {
    return TextButton(
      onPressed: () => setState(() {
        screenSize = screenSizeData;
      }),
      child: Text(screenSizeData.name),
    );
  }
}

class Page extends StatelessWidget {
  const Page(this.pageData, {Key? key}) : super(key: key);

  final PageData pageData;

  @override
  Widget build(BuildContext context) {
    // print("${pageData.name} rebuilding");
    return Scaffold(
      body: Text(pageData.name),
    );
  }
}

class ScreenSize {
  ScreenSize({required this.heightInMM, required this.widthInMM, required this.name});

  final double widthInMM;
  final double heightInMM;
  final String name;

  double get widthInPx => (widthInMM / 10) * 38;

  double get heightInPx => (heightInMM / 10) * 38;
}

/// so this is kind of useless, if everything is based on logical pixels.
/// in stead, ill calculate the actual screen sizes and use those measures
// var ScreenSizes = [
//   ScreenSize(width: 375, height: 667, name: "Little Phone"),
//   ScreenSize(width: 390, height: 844, name: "Regular Phone"),
//   ScreenSize(width: 414, height: 896, name: "Big Phone"),
//   ScreenSize(width: 540, height: 720, name: "Little Tablet"),
//   ScreenSize(width: 768, height: 1024, name: "Regular Tablet"),
//   ScreenSize(width: 912, height: 1368, name: "Big Tablet"),
//   ScreenSize(width: double.infinity, height: double.infinity, name: "Available Space"),
// ];

// class ScreenSize {
//   ScreenSize({required this.height, required this.width, required this.name});
//
//   final double width;
//   final double height;
//   final String name;
//
//
//
// }
