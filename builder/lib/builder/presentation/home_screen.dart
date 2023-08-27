// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';

/// Sections
import 'classes/classesSection.dart';
import 'ui/UISection.dart';
import 'package:provider/provider.dart';
import '../state/state.dart';
// Widgets
import 'hotkeyBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController globalController = TextEditingController();

  void startSaveTimer(Function fn) {
    Timer.periodic(const Duration(seconds: 2), (timer) => fn());
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AllState>(context);

    startSaveTimer(state.save);

    return Scaffold(
      body: GestureDetector(
        onTap: () => state.rawkeyFocus.requestFocus(),
        child: RawKeyboardListener(
          onKey: (event) {
            if (event.runtimeType.toString() == "RawKeyDownEvent") {
              // print(event.character);
              if (event.data.keyLabel != null) {
                state.recieveKeypress(event.data.keyLabel);
              }
            }
          },
          focusNode: state.rawkeyFocus,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/horizonWallpaper.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: [
                  TextField(
                    focusNode: state.textInputFocus,
                    controller: state.textController,
                    onChanged: (val) => state.textInputFunction(val),
                    onSubmitted: (_) {state.rawkeyFocus.requestFocus(); state.textController.clear();},
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Flexible(
                          flex: 3,
                          child: ClassSection(),
                        ),
                        Flexible(
                          flex: 9,
                          child: UISection(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(child: HotkeyBar()),
                  ),
                  SizedBox(
                    height: 25,
                    child: Center(
                        child: Text(
                            "Last Action: ${state.lastActionExplanation}")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
