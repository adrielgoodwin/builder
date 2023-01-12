import 'package:flutter/material.dart';

// A fun thing to do later

class Texter {



}


class FlexSectionController {
  
  int flex;
  bool locked;
  
  FlexSectionController({this.locked = false, this.flex = 3});
  
}

class FlexSection extends StatelessWidget {
  const FlexSection({Key? key, required this.controller, required this.child}) : super(key: key);

  final Widget child;
  final FlexSectionController controller;
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(child: Column(
        children: [

        ],
      )),
      flex: controller.flex,
    );
  }
}
