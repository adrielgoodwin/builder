import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/focusProvider.dart';
import '../state/class_maker_provider.dart';

class FocusClassMakerIntent extends Intent {}

class FocusClassMakerAction extends Action<FocusClassMakerIntent> {
  FocusClassMakerAction(this.focusProvider);

  final FocusProvider focusProvider;

  @override
  void invoke(FocusClassMakerIntent intent) {
    focusProvider.CM.requestFocus();
    print("requested focus for ClassMaker");
  }

}

class TopActions {

  final FocusProvider focusProvider;

  TopActions(FocusProvider fp) : focusProvider = fp;

  late var actions = {
    FocusClassMakerIntent: FocusClassMakerAction(focusProvider),
  };

  late var shortcuts = {
    LogicalKeySet(LogicalKeyboardKey.digit1): FocusClassMakerIntent(),
  };

  void test(RawKeyEvent keyEvent) => print(keyEvent.logicalKey);

}