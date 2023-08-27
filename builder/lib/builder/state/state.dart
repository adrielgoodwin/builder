// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';

import '../extensions.dart';

import '../MetaWidgetTreeBuilder/meta_tree.dart';

import 'package:flutter/material.dart';
// import '../actions/actionsSocket.dart';
import '../actions/actionPlug.dart';
import '../models/class_data.dart';
import '../models/field_data.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import '../colors/colors.dart';

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
  ///
  ///
  /// Saving
  ///
  ///

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/code/builder/registry.json');
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
    // writejson(json.encode(registry.toMap()));
  }

  ///
  ///
  /// Action Plugs ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  ///
  ///

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
    print("Keypress: $keyPress");
    if (!textInputFocus.hasFocus) {
      // Check if keypress is in our Keys enum (actionSocket > stringKeys > Keys)
      if (stringKeys.containsKey(keyPress)) {
        activePlug.execute(stringKeys[keyPress]!);
        // lastActionExplanation =
        //     activePlug.funcExplanations[stringKeys[keyPress]]!;
        notifyListeners();
      }
    }
  }

  late Map<ActionPlugs, ActionPlug> plugMap = {
    ActionPlugs.classes: classesPlug,
    ActionPlugs.classChanger: classChangerPlug,
    // ActionPlugs.ui: uiPlug,
    ActionPlugs.topLevel: topLevelPlug,
  };


  ///
  ///
  /// Top level 'global' sort of actions ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  ///
  ///


  late ActionPlug topLevelPlug = ActionPlug(
    [],
  );

  ///
  ///
  /// Class Making Actions
  ///
  ///

  /// CLASSES
  /// Section where classes are filtered through and added ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

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

  late ActionPlug classesPlug = ActionPlug([
    KeyFunction(
      key: Keys.r, 
      color: C.gold, 
      action: () => setActivePlug(ActionPlugs.ui), 
      definition:  "Move to <UI>",
    ),
    KeyFunction(
      key: Keys.enter, 
      color: C.gold, 
      action: () => setActivePlug(ActionPlugs.classChanger), 
      definition:  "Select Class",
    ),
    KeyFunction(
      key: Keys.c, 
      color: C.gold, 
      action: () => setSelectedClassIndex(1), 
      definition:  "Select class below",
    ),
    KeyFunction(
      key: Keys.v, 
      color: C.gold, 
      action: () => setSelectedClassIndex(-1), 
      definition:  "Select class above",
    ),
    KeyFunction(
      key: Keys.j, 
      color: C.gold, 
      action: () {
        textInputFocus.requestFocus();
        setTextInputFunction(setClassName);
      }, 
      definition:  "Set class name",
    ),
    KeyFunction(
      key: Keys.n, 
      color: C.gold, 
      action: () => addClass(), 
      definition:  "Add class",
    ),
  ]);

  // CLASS CHANGER
  // Section where classes are changed ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

  var selectedFieldIndex = 0;

  FieldData get selectedField =>
      classes[selectedClassIndex].fieldData[selectedFieldIndex];

  void setSelectedFieldIndex(int direction) {
    selectedFieldIndex = getNewIndex(direction,
        classes[selectedClassIndex].fieldData.length, selectedFieldIndex);
    notifyListeners();
  }
  
  void addField() {
    // Add a field to class
    classes[selectedClassIndex]
        .fieldData
        .insert(selectedFieldIndex, FieldData(id: newId()));
  }
  
  void setField(FieldData field) {
    classes[selectedClassIndex].fieldData[selectedFieldIndex] = field;
    notifyListeners();
  }

  void setFieldByClassName(FieldData field, String className) {
    var classIndex = classes.indexWhere((element) => element.name == className);
    var fieldIndex = classes[classIndex].fieldData.indexOf(field);
    classes[classIndex].fieldData[fieldIndex] = field;
  }

  void setFieldName(String name) {
    var field = selectedField;
    field.name = name.paramify();
    setField(field);
  }

  void setFieldType(String type) {
    var field = selectedField;
    field.type = type;
    setField(field);
  }

  void setFieldDesc(String description) {
    var field = selectedField;
    field.description = description;
    setField(field);
  }

  void setFieldDescription(String description, String fieldName, String className) {
    var ciq = classes.firstWhere((element) => element.name == className); // class in question
    var fiq = ciq.fieldData.firstWhere((element) => element.name == fieldName);
    fiq.description = description;
    setFieldByClassName(fiq, className);
  }



  void toggleIsAList() {
    var field = selectedField;
    selectedField.isAList ? field.isAList = false : field.isAList = true;
    setField(field);
  }
  late ActionPlug classChangerPlug = ActionPlug([
    KeyFunction(
      key: Keys.q,
      color: C.gold, 
      action: () => setActivePlug(ActionPlugs.classes), 
      definition: "Deselect class",
    ),
    KeyFunction(
      key: Keys.c,
      color: C.gold, 
      action: () => setSelectedFieldIndex(1),
      definition: "Select field below",
    ),
    KeyFunction(
      key: Keys.v,
      color: C.gold, 
      action: () => setSelectedFieldIndex(-1),
      definition: "Select field above",
    ),
    KeyFunction(
      key: Keys.v,
      color: C.gold, 
      action: () => setSelectedFieldIndex(-1),
      definition: "Select field above",
    ),
    KeyFunction(
      key: Keys.a,
      color: C.teal, 
      action: () => setFieldType('int'),
      definition: "Int",
    ),
    KeyFunction(
      key: Keys.s,
      color: C.teal, 
      action: () => setFieldType('String'),
      definition: "String",
    ),
    KeyFunction(
      key: Keys.d,
      color: C.teal, 
      action: () => setFieldType('DateTime'),
      definition: "DateTime",
    ),
    KeyFunction(
      key: Keys.f,
      color: C.teal, 
      action: () => setFieldType('Double'),
      definition: "Float",
    ),
    KeyFunction(
      key: Keys.k,
      color: C.teal, 
      action: () {
        // Type in class
      },
      definition: "Set Klass",
    ),
    KeyFunction(
      key: Keys.k,
      color: C.teal, 
      action: () => toggleIsAList(),
      definition: "Set Klass",
    ),
    KeyFunction(
      key: Keys.enter,
      color: C.teal, 
      action: () {
      textInputFocus.requestFocus();
      setTextInputFunction(setFieldName);
    },
      definition: "Change Name",
    ),
    KeyFunction(
      key: Keys.n,
      color: C.teal, 
      action: () => addField(),
      definition: "Add Field",
    ),
  ]);









  // User Interface
  // Section where user interface is configured ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 




































  ///
  ///
  ///    Text input
  ///
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
