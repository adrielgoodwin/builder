// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';

import '../extensions.dart';

import 'package:flutter/material.dart';
import '../actions/actionsSocket.dart';
import '../models/class_data.dart';
import '../models/field_data.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

import '../models/registry.dart';
import '../models/class_register.dart';

ClassData initClass =
    ClassData(id: 'id1234123', fieldData: [FieldData(id: 'asfsd')]);

var uuid = const Uuid();

String newId() {
  return uuid.v1();
}

int getNewIndex(int direction, int length, int current) {
  // 4 length, current is on 3. direction is 1. already at end so if direction is 1 go back to beginning
  if (current + direction >= length) return 0;
  // if current is 0 and direction is -1, go to end of list
  if (current + direction < 0) return length - 1;
  return current + direction;
}

enum ActionPlugs { classes, ui, classChanger, topLevel }

/// State

class AllState with ChangeNotifier {

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/Adriel/builder-rewrite/registry.json');
  }

  Future<File> writejson(String json) async {
    final file = await localFile;
    // Write the file
    return file.writeAsString(json);
  }

  void loadRegistries() async {
    var data = await localFile;
    var jsonString = await data.readAsString();
    var registry = Registry.fromJson(json.decode(jsonString));
    for (var element in registry.registeredClasses) {
      classes.add(element.classData);
      notifyListeners();
    }
  }

  void save() {
    List<ClassRegister> classRegisters = [];
    for (var element in classes) {
      classRegisters
          .add(ClassRegister(classData: element, dateModified: "dateModified"));
    }
    var registry =
        Registry(appName: "Current App", registeredClasses: classRegisters);
    writejson(json.encode(registry.toMap()));
  }

  ActionPlugs activePlugEnum = ActionPlugs.classes;

  late ActionPlug activePlug = plugMap[ActionPlugs.classes]!;

  String lastActionExplanation = "Nothing happened yet";

  void setActivePlug(ActionPlugs actionPlug) {
    activePlug = plugMap[actionPlug]!;
    activePlugEnum = actionPlug;
    notifyListeners();
  }

  var rawkeyFocus = FocusNode();

  void recieveKeypress(String keyPress) {
    if (!textInputFocus.hasFocus) {
      // Check if keypress is in our Keys enum (actionSocket > stringKeys > Keys)
      if (stringKeys.containsKey(keyPress)) {
        activePlug.execute(stringKeys[keyPress]!);
        lastActionExplanation =
            activePlug.funcExplanations[stringKeys[keyPress]]!;
        notifyListeners();
      }
    }
  }

  late Map<ActionPlugs, ActionPlug> plugMap = {
    ActionPlugs.classes: classesPlug,
    ActionPlugs.classChanger: classChangerPlug,
    ActionPlugs.ui: uiPlug,
    ActionPlugs.topLevel: topLevelPlug,
  };

  /// CLASSES
  /// Section where classes are filtered through and added

  late List<ClassData> classes = [initClass];

  int selectedClassIndex = 0;

  ClassData get selectedClass => classes[selectedClassIndex];

  void setSelectedClassIndex(int direction) {
    selectedClassIndex =
        getNewIndex(direction, classes.length, selectedClassIndex);
    notifyListeners();
  }

  void setClassName(String name) {
    var elClass = selectedClass;
    elClass.name = name;
    classes[selectedClassIndex] = elClass;
    notifyListeners();
  }

  void addClass() {
    classes.insert(selectedClassIndex,
        ClassData(id: newId(), fieldData: [FieldData(id: newId())]));
    notifyListeners();
  }

  late ActionPlug topLevelPlug = ActionPlug(
    backOut: () {},
    backOutExpl: "",
    left: () {},
    leftExpl: "",
    right: () {},
    rightExpl: "",
    select: () {},
    selectExpl: "",
    down: () {},
    downExpl: "",
    up: () {},
    upExpl: "",
    actionj: () {},
    actionjExpl: "",
    actionk: () {},
    actionkExpl: "",
    actionl: () {},
    actionlExpl: "",
    actionSemicolon: () {},
    actionSemicolonExpl: "",
    actionNew: () {},
    actionNewExpl: "",
  );

  late ActionPlug classesPlug = ActionPlug(
      backOut: () => print('in classes plug'),
      backOutExpl: "Backout to global",
      left: () => print('left'),
      leftExpl: "",
      right: () => setActivePlug(ActionPlugs.ui),
      rightExpl: "Move to <UI>",
      select: () => setActivePlug(ActionPlugs.classChanger),
      selectExpl: "Select class",
      down: () => setSelectedClassIndex(1),
      downExpl: "Select class below",
      up: () => setSelectedClassIndex(-1),
      upExpl: "Select class above",
      actionj: () {},
      actionjExpl: "",
      actionk: () => print('action k'),
      actionkExpl: "",
      actionl: () {
        textInputFocus.requestFocus();
        setTextInputFunction(setClassName);
      },
      actionlExpl: "Set class name",
      actionSemicolon: () => print('action semicolon'),
      actionSemicolonExpl: "",
      actionNew: () => addClass(), // Add Class
      actionNewExpl: "Create a new class");

  // CLASS CHANGER
  // Section where classes are changed

  var selectedFieldIndex = 0;

  FieldData get selectedField =>
      classes[selectedClassIndex].fieldData[selectedFieldIndex];

  void setField(FieldData field) {
    classes[selectedClassIndex].fieldData[selectedFieldIndex] = field;
    notifyListeners();
  }

  void setSelectedFieldIndex(int direction) {
    selectedFieldIndex = getNewIndex(direction,
        classes[selectedClassIndex].fieldData.length, selectedFieldIndex);
    notifyListeners();
  }

  void setFieldName(String name) {
    print(name);
    var field = selectedField;
    field.name = name.paramify();
    setField(field);
  }

  void setFieldType(int direction) {
    var field = selectedField;
    var types = ['String', 'int', 'double', 'DateTime'];
    var typeIndex = types.indexOf(selectedField.type);
    field.type = types[getNewIndex(1, 4, typeIndex)];
    setField(field);
  }

  void addField() {
    // Add a field to class
    classes[selectedClassIndex]
        .fieldData
        .insert(selectedFieldIndex, FieldData(id: newId()));
  }

  void toggleIsAList() {
    var field = selectedField;
    selectedField.isAList ? field.isAList = false : field.isAList = true;
    setField(field);
  }

  late ActionPlug classChangerPlug = ActionPlug(
    backOut: () => setActivePlug(ActionPlugs.classes),
    backOutExpl: "Deselect class",
    left: () {},
    leftExpl: "",
    right: () {},
    rightExpl: "",
    select: () {},
    selectExpl: "",
    down: () => setSelectedFieldIndex(1),
    downExpl: "Select field below",
    up: () => setSelectedFieldIndex(-1),
    upExpl: "Select field above",
    actionj: () => setFieldType(1),
    actionjExpl: "Iterate through types",
    actionk: () => toggleIsAList(),
    actionkExpl: "Toggle is a list",
    actionl: () {
      print("action L");
      textInputFocus.requestFocus();
      setTextInputFunction(setFieldName);
    },
    actionlExpl: "Change field name",
    actionSemicolon: () => {},
    actionSemicolonExpl: "",
    actionNew: () => addField(),
    actionNewExpl: "Add field to class",
  );

  // User Interface
  // Section where user interface is configured

  late ActionPlug uiPlug = ActionPlug(
    backOut: () => {},
    backOutExpl: "",
    left: () => setActivePlug(ActionPlugs.classes),
    leftExpl: "Back to classes",
    right: () {},
    rightExpl: "",
    select: () {}, // set field name
    selectExpl: "",
    down: () {},
    downExpl: "",
    up: () => {},
    upExpl: "",
    actionj: () {},
    actionjExpl: "",
    actionk: () {},
    actionkExpl: "",
    actionl: () => {},
    actionlExpl: "",
    actionSemicolon: () => {},
    actionSemicolonExpl: "",
    actionNew: () {
      // Add a field to class
      classes[selectedClassIndex]
          .fieldData
          .insert(selectedFieldIndex, FieldData(id: newId()));
    },
    actionNewExpl: "Add field to class",
  );

  ///
  ///
  ///    Text input
  ///

  FocusNode textInputFocus = FocusNode();

  TextEditingController textController = TextEditingController();

  Function textInputFunction = () {};

  void setTextInputFunction(Function fn) {
    textInputFunction = fn;
    textController.clear();
    notifyListeners();
  }
}
