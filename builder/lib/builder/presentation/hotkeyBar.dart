// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import '../actions/actionPlug.dart';
import '../state/state.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:fluttericon/linecons_icons.dart';

class HotkeyBar extends StatefulWidget {
  const HotkeyBar({Key? key}) : super(key: key);

  @override
  State<HotkeyBar> createState() => _HotkeyBarState();
}

class _HotkeyBarState extends State<HotkeyBar> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_literals_to_create_immutables
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white70.withOpacity(0.000000001),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.white24,
            blurRadius: 12,
          ),
        ],
      ),
      child: KeyExplFuncs(),
    );
  }
}

class KeyExplFuncs extends StatelessWidget {
  const KeyExplFuncs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var workingWidth = MediaQuery.of(context).size.width;
    var keySectionWidth = workingWidth / 10;
    var activePlug = Provider.of<AllState>(context).activePlug;
    var activeKeyFunctions = keyFunctions;
    activePlug.keyFunctions.forEach((element) {
        activeKeyFunctions.replaceRange(keyFunctionsIndexMap[element!.key]!, keyFunctionsIndexMap[element.key]! + 1, [element]);
      
    });
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Wrap(children: [
        ...keyFunctions.map((e) => keyExplanationFunction(keyStrings[e.key]!,  e.definition, e.action, e.color, keySectionWidth)).toList()
      ],)
    );
  }
}

Widget keyExplanationFunction(String key, String explanationText,
    Function function, Color color, double width,
    {double stagger = 0}) {
  return Container(
  alignment: Alignment.center,
    // decoration: BoxDecoration(
    //     color: Colors.amber.shade200,
    //     border: Border.all(),
    //     borderRadius: BorderRadius.circular(5)),
    width: width - 10,
    height: 70,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: stagger,
        ),
        GestureDetector(
          child: keyboardKey(key, color),
          onTap: () => function(),
        ),
        explanation(explanationText, color),
      ],
    ),
  );
}

Widget explanation(String explanation, Color color) {
  return Flexible(
      child: Text(
    explanation,
    style: TextStyle(color: color),
    textAlign: TextAlign.center,
  ));
}

Widget keyboardKey(String key, Color color) {
  return Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        border: Border.all(color: color),
        boxShadow: [
          BoxShadow(
            blurRadius: 7,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
        borderRadius: BorderRadius.circular(5)),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // SizedBox(width: 5,),
          Text(
            key,
            style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}
