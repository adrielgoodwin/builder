// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../state/class_maker_provider.dart';
import '../state/focusProvider.dart';


class FocusTopIntent extends Intent {}

class FocusTopAction extends Action<FocusTopIntent> {
  FocusTopAction(this.focusProvider);
  final FocusProvider focusProvider;
  @override
  void invoke(FocusTopIntent intent) {
    focusProvider.TOP.requestFocus();
    print("Requesting Top Focus");
  }
}

class ToggleFormI extends Intent {}

class ToggleFormA extends Action<ToggleFormI> {
  ToggleFormA(this.cmp);
  final ClassMakerProvider cmp;
  @override
  void invoke(ToggleFormI intent) {
    print("got gere");
    cmp.beginNewClass();
    cmp.setIsMakingNewClass(!cmp.isMakingNewClass);
    cmp.setNewClassBox(cmp.isMakingNewClass ? 250 : 0);
  }
}

class ClassMakerActions {

  final ClassMakerProvider cmp;
  final FocusProvider focusProvider;

  ClassMakerActions(this.focusProvider, this.cmp);

  // final ClassMakerProvider cmprovider;
  //
  // ClassMakerActions[this.cmprovider];

  /// Give

  /// While entire section is selected

  late var actions = <Type, Action<Intent>>{
    FocusTopIntent: FocusTopAction(focusProvider),
    ToggleFormI: ToggleFormA(cmp),
  };

  late var shortcuts = {
    LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.space): FocusTopIntent(),
    LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN): ToggleFormI(),
  };


  // [ 1 ] Selects Class Maker Section

    /// @ClassMakerSection
    // [ N ] Open Add Class Form
      /// @Classname text-field selected
      // [ Enter ] Focus
      // {
      // [ Shift + N ] Focus ClassName
      // [ N ] New field
        // [ S ] String
        // [ B ] Boolean
        // [ I ] Int
        // [ D ] Double
        // [ C ] Class
          // [ LEFT ] / [ RIGHT ] Navigate Classes
          // [ ENTER ] Choose Class
        // [ L ] IsList
        // [ N ] Focus Name TextField
          // [ ENTER ] Focus Back to Field
    // [ Enter ]

  // 2. [ Enter ] Select first class in list

  /// While

}