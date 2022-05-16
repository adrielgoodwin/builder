// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../state/classProvider.dart';
// import '../state/class_maker_provider.dart';
//
// ///
// /// This is every possible action within the application
// /// Get to section by 'finding' < SectionName >
// /// Class Section (section 1)
// ///
// /// For every set of actions we have:
// /// Enum with each possible action
// ///
//
// // Top level
// enum Top { focusSection1, focusSection2, focusSection3 }
// e
// var topFN = FocusNode();
//
// class FocusSection1Intent extends Intent {}
//
// class FocusTopAction extends Action<FocusSection1Intent> {
//   @override
//   void invoke(FocusSection1Intent intent) {
//     section1FN.requestFocus();
//     print("Requesting Focus - Section 1");
//   }
// }
//
// enum Section1 { openClassForm, focusTop }
//
// var section1FN = FocusNode();
//
// class Actions {
//   Actions(this.cmp, this.cp);
//
//   final ClassProvider cp;
//   final ClassMakerProvider cmp;
//
//   // Top level actions
//
//   Map<Top, List<LogicalKeyboardKey>> topKeybindings = {
//     Top.focusSection1: [LogicalKeyboardKey.digit1],
//     Top.focusSection2: [LogicalKeyboardKey.digit2],
//     Top.focusSection3: [LogicalKeyboardKey.digit3],
//   };
//
//   Map<Top, Intent> topIntents = {
//     Top.focusSection1: FocusSection1Intent(),
//   };
//
//
// }
//
//
//
