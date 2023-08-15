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
    state.loadState();

    // startSaveTimer(state.save);

    return Scaffold(
      body: GestureDetector(
        onTap: () => state.rawkeyFocus.requestFocus(),
        child: RawKeyboardListener(
          onKey: (event) {
            if (event.runtimeType.toString() == "RawKeyDownEvent") {
              if (event.character != null) {
                state.recieveKeypress(event.character!);
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
                  Opacity(
                    opacity: 0,
                    child: TextField(
                      focusNode: state.textInputFocus,
                      controller: state.textController,
                      onChanged: (val) {
                        if(state.flags.textEditingWorkaround) {
                          state.textInputFunction(val);
                        }
                        state.flags.textEditingWorkaround = true;
                        state.notifyListeners();
                      },
                      onSubmitted: (_) {
                        state.rawkeyFocus.requestFocus();
                        state.textController.clear();
                        state.flags.clear();
                        state.notifyListeners();
                      },
                    ),
                  ),
                  const Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
