import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import '../actions/actionsSocket.dart';
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
    var activePlug = Provider.of<AllState>(context).activePlug;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 625,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Navigation",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    keyExplanationFunction(
                        "A",
                        Transform.rotate(
                            angle: -45 * math.pi / 180,
                            child: const Icon(Icons.arrow_upward)),
                        activePlug.backOutExpl,
                        activePlug.backOut,
                        activePlug.backOutExpl.isNotEmpty
                            ? Colors.amber
                            : Colors.grey,
                        stagger: 35),
                    keyExplanationFunction(
                        "S",
                        const Icon(Icons.arrow_back_rounded),
                        activePlug.leftExpl,
                        activePlug.left,
                        activePlug.leftExpl.isNotEmpty
                            ? Colors.amber
                            : Colors.grey),
                    keyExplanationFunction(
                        "D",
                        const Icon(Icons.arrow_forward_rounded),
                        activePlug.rightExpl,
                        activePlug.right,
                        activePlug.rightExpl.isNotEmpty
                            ? Colors.amber
                            : Colors.grey,
                        stagger: 35),
                    keyExplanationFunction(
                        "G",
                        const Icon(Icons.arrow_upward_rounded),
                        activePlug.downExpl,
                        activePlug.down,
                        activePlug.downExpl.isNotEmpty
                            ? Colors.amber
                            : Colors.grey),
                    keyExplanationFunction(
                        "H",
                        const Icon(Icons.arrow_downward_rounded),
                        activePlug.upExpl,
                        activePlug.up,
                        activePlug.upExpl.isNotEmpty
                            ? Colors.amber
                            : Colors.grey,
                        stagger: 35),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Selection",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                keyExplanationFunction(
                    "F",
                    const Icon(LineariconsFree.select),
                    activePlug.selectExpl,
                    activePlug.select,
                    activePlug.selectExpl.isNotEmpty
                        ? Colors.green
                        : Colors.grey)
              ],
            ),
          ),
          Container(
            // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            width: 650,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Actions",
                  style: TextStyle(
                      color: Color.fromRGBO(229, 104, 64, 2),
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  keyExplanationFunction(
                  "N",
                  const Icon(Icons.add),
                  activePlug.actionNewExpl,
                  activePlug.actionNew,
                  activePlug.actionNewExpl.isNotEmpty
                      ? Color.fromRGBO(229, 104, 64, 2)
                      : Colors.grey,
                  stagger: 35,
                ),
                keyExplanationFunction(
                  "J",
                  const Icon(Icons.handyman),
                  activePlug.actionjExpl,
                  activePlug.actionj,
                  activePlug.actionjExpl.isNotEmpty
                      ? Color.fromRGBO(229, 104, 64, 2)
                      : Colors.grey,
                ),
                keyExplanationFunction(
                  "K",
                  const Icon(Icons.handyman),
                  activePlug.actionkExpl,
                  activePlug.actionk,
                  activePlug.actionkExpl.isNotEmpty
                      ? Color.fromRGBO(229, 104, 64, 2)
                      : Colors.grey,
                  stagger: 35,
                ),
                keyExplanationFunction(
                  "L",
                  const Icon(Icons.handyman),
                  activePlug.actionlExpl,
                  activePlug.actionl,
                  activePlug.actionlExpl.isNotEmpty
                      ? Color.fromRGBO(229, 104, 64, 2)
                      : Colors.grey,
                ),
                keyExplanationFunction(
                  ";",
                  const Icon(Icons.handyman),
                  activePlug.actionSemicolonExpl,
                  activePlug.actionSemicolon,
                  activePlug.actionSemicolonExpl.isNotEmpty
                      ? Color.fromRGBO(229, 104, 64, 2)
                      : Colors.grey,
                  stagger: 35,
                ),
                ],)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget keyExplanationFunction(String key, Widget icon, String explanationText,
    Function function, Color color,
    {double stagger = 0}) {
  return Container(
    // decoration: BoxDecoration(
    //     color: Colors.amber.shade200,
    //     border: Border.all(),
    //     borderRadius: BorderRadius.circular(5)),
    width: 125,
    height: 130,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: stagger,
        ),
        GestureDetector(
          child: keyboardKey(key, icon, color),
          onTap: () => function(),
        ),
        const SizedBox(
          width: 20,
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

Widget keyboardKey(String key, Widget icon, Color color) {
  return Container(
    width: 55,
    height: 55,
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
          icon,
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
