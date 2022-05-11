// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// provider
import '../state/class_maker_provider.dart';
import '../state/global_input_provider.dart';
import '../state/focusProvider.dart';
// composition
import '../file_composers/composerFunctions.dart';

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
  ToggleFormA(this.cmp, this.fp);
  final ClassMakerProvider cmp;
  final FocusProvider fp;
  @override
  void invoke(ToggleFormI intent) {
    cmp.beginNewClass();
    cmp.setIsMakingNewClass(!cmp.isMakingNewClass);
    cmp.setNewClassBox(cmp.isMakingNewClass ? 250 : 0);
    fp.CC.requestFocus();
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
    ToggleFormI: ToggleFormA(cmp, focusProvider),
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

// Set type

class SetTypeI extends Intent {
  final String type;
  final int index;
  const SetTypeI(this.type, this.index);
}

class SetTypeAction extends Action<SetTypeI> {
  final ClassMakerProvider cmp;
  SetTypeAction(this.cmp);

  @override
  void invoke(SetTypeI intent) {
    var field = cmp.newClass.fieldData.elementAt(intent.index);
    field.type = intent.type;
    cmp.setField(intent.index, field);
    print(intent.type);
  }
}

// Set field name
class SetFieldNameI extends Intent {
  const SetFieldNameI(this.index);
  final int index;
}

class SetFieldNameA extends Action<SetFieldNameI> {
  SetFieldNameA(this.cmp, this.gip, this.fp);
  final ClassMakerProvider cmp;
  final GlobalInputProvider gip;
  final FocusProvider fp;

  @override
  void invoke(SetFieldNameI intent) {
    var field = cmp.newClass.fieldData[intent.index];
    field.name = "";
    cmp.setField(intent.index, field);
    gip.setFunction((value) {
      var field = cmp.newClass.fieldData[intent.index];
      field.name = value;
      cmp.setField(intent.index, field);
    });
    gip.focus(fp.CC);
  }
}

// Add field

class AddFieldI extends Intent {
  const AddFieldI(this.index);
  final int index;
}

class AddFieldA extends Action<AddFieldI> {
  AddFieldA(this.cmp);
  ClassMakerProvider cmp;

  @override
  void invoke(AddFieldI intent) {
    print("adding field at ${intent.index}");
    cmp.addField(intent.index);
  }
}

// Move selection

class ChangeSelectionI extends Intent {
  const ChangeSelectionI(this.newSelection);
  final int newSelection;
}

class ChangeSelectionA extends Action<ChangeSelectionI> {
  ChangeSelectionA(this.cmp);
  final ClassMakerProvider cmp;
  @override
  void invoke(ChangeSelectionI intent) {
    if(cmp.newClass.fieldData.length > intent.newSelection && intent.newSelection >= 0) {
      cmp.setSelectedIndex(intent.newSelection);
    }
  }
}

class SetClassNameI extends Intent {}

class SetClassNameA extends Action<SetClassNameI> {
  SetClassNameA(this.cmp, this.gip, this.fp);
  final ClassMakerProvider cmp;
  final GlobalInputProvider gip;
  final FocusProvider fp;

  @override
  void invoke(SetClassNameI intent) {
    gip.setFunction(cmp.setClassName);
    gip.focus(fp.CC);
  }
}

class SubmitClassI extends Intent {}

class SubmitClassA extends Action<SubmitClassI> {
  SubmitClassA(this.cmp, this.fp);
  final ClassMakerProvider cmp;
  final FocusProvider fp;

  @override
  void invoke(SubmitClassI intent) {
    writeClass(cmp.newClass);
    // get other classes from ClassProvider
    // add the new class and write the registry
    //
  }
}

class ClassFormActions {
  ClassFormActions(this.focusProvider, this.cmp, this.gip);
  final ClassMakerProvider cmp;
  final FocusProvider focusProvider;
  final GlobalInputProvider gip;

  late var actions = <Type, Action<Intent>>{
    SetTypeI: SetTypeAction(cmp),
    AddFieldI: AddFieldA(cmp),
    ChangeSelectionI: ChangeSelectionA(cmp),
    SetClassNameI: SetClassNameA(cmp, gip, focusProvider),
    SetFieldNameI: SetFieldNameA(cmp, gip, focusProvider),
    SubmitClassI: SubmitClassA(cmp, focusProvider),
  };

  late var shortcuts = {
    // Set ClassName
    LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.keyN): SetClassNameI(),
    // Set Field Name
    LogicalKeySet(LogicalKeyboardKey.enter): SetFieldNameI(cmp.selectedIndex),
    // Set Data-type
    LogicalKeySet(LogicalKeyboardKey.keyS): SetTypeI('String', cmp.selectedIndex),
    LogicalKeySet(LogicalKeyboardKey.keyI): SetTypeI('int', cmp.selectedIndex),
    LogicalKeySet(LogicalKeyboardKey.keyD): SetTypeI('double', cmp.selectedIndex),
    LogicalKeySet(LogicalKeyboardKey.keyT): SetTypeI('DateTime', cmp.selectedIndex),
    LogicalKeySet(LogicalKeyboardKey.keyC): SetTypeI('Class', cmp.selectedIndex),
    // Add field to position
    LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.keyB): AddFieldI(cmp.selectedIndex + 1),
    LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.keyA): AddFieldI(cmp.selectedIndex),
    // Set selected index
    LogicalKeySet(LogicalKeyboardKey.tab): ChangeSelectionI(cmp.selectedIndex + 1),
    LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab): ChangeSelectionI(cmp.selectedIndex - 1),
    LogicalKeySet(LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.enter): SubmitClassI(),
  };

}



