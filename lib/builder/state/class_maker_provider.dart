import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:builder/builder/models/field_data.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

// models
import '../models/class_data.dart';
import '../models/registry.dart';

// write files api
import '../write_files_api.dart';

// functions that will compose and write a file
import '../file_composers/composerFunctions.dart';

// widgets
import '../presentation/class_maker/new_class_field_input.dart';

class ClassMakerProvider with ChangeNotifier {

  var uuid = const Uuid();

  /// Class Maker Section UI

  double _newClassBox = 0;
  void setNewClassBox(double x) {
    _newClassBox = x;
    print("New class box is $x");
    notifyListeners();
  }
  double get newClassBox => _newClassBox;

  bool _isMakingNewClass = false;
  void setIsMakingNewClass(bool x) {
    _isMakingNewClass = x;
    notifyListeners();
  }
  bool get isMakingNewClass => _isMakingNewClass;

  bool _classIsGood = false;
  void setClassIsGood(bool x) {
    _classIsGood = x;
    notifyListeners();
  }

  /// New Class Form

  late ClassData _newClass;

  ClassData get newClass => _newClass;

  Map<String, Widget> _fieldWidgets = {};

  List<Widget> get fieldWidgets => _fieldWidgets.values.toList();

  void beginNewClass() {
    _newClass = ClassData(name: 'NewClass', id: uuid.v1(), fieldData: [FieldData(id: uuid.v1())]);
    notifyListeners();
  }

  void updateClassName(String newName) {
    _newClass.name = newName;
    notifyListeners();
  }

  // void addField() {
  //   var id = uuid.v1();
  //   var field = FieldData(id: id);
  //   _fieldWidgets[id] = NewClassFieldInput(
  //     fieldId: id,
  //     removeWidget: removeField,
  //   );
  //   _newClass.fieldData = [..._newClass.fieldData, field];
  //   notifyListeners();
  // }

  void updateField(FieldData fieldData) {
    newClass.fieldData[newClass.fieldData.indexWhere((element) => element.id == fieldData.id)] = fieldData;
  }

  void removeField(String fieldId) {
    if(fieldWidgets.length > 1) {
      newClass.fieldData.removeWhere((element) => element.id == fieldId);
      _fieldWidgets.removeWhere((key, value) => key == fieldId);
      notifyListeners();
    }
  }

  Future<String> tryWritingClass() async {
    for (var c in _existingClasses.values) {
      if (c.name == newClass.name) {
        return "A class with this name already exists";
      }
    }
    printFieldDatas(newClass);
    var successful = await writeClass(newClass);
    if (successful) {
      _existingClasses.addAll({newClass.id: newClass});
      // _newClasses.remove(classData.id);
      notifyListeners();
      return "Created new class ${newClass.name}";
    }
    return "Could not create class";
  }

  // this is here to keep the state of classes in creation when navigation occurs
  Map<String, ClassData> _existingClasses = {};

  List<ClassData> get existingClasses => _existingClasses.values.toList();

  String updateExistingClass(ClassData classData) {
    _existingClasses.update(classData.id, (value) => classData);
    notifyListeners();
    return "Updated ${classData.name}";
  }

  Future deleteClass(ClassData classData) async {
    var className = classData.name;
    print("trying to delete: $className");
    _existingClasses.forEach((key, value) {
      print(key);
    });

    // Remove Class Data File
    await sendDeleteRequest(Paths.dataClasses + className + '.dart');
    // Remove Form File
    await sendDeleteRequest(Paths.ioForms + className + 'Form.dart');
    // Remove Record File
    await sendDeleteRequest(
        Paths.ioRecordDisplays + className + 'Records.dart');
    _existingClasses.remove(classData.id);
    writeRegistry(existingClasses);
    writeProvider(existingClasses);
    notifyListeners();
  }

  void loadClassesIntoMapFromRegistry() {
    for (var classRegister in _registry.registeredClasses) {
      _existingClasses[classRegister.classData.id] = classRegister.classData;
    }
    // for (var classRegister in _builderRegistry.registeredClasses) {
    //   _builderClassesMap[classRegister.classData.id] = classRegister.classData;
    // }
    print(_existingClasses.values.toList());

    notifyListeners();
  }

  ///
  /// Registries.
  /// These are the representation of the actual json file that stores the data for the classes.
  /// Only used as structured to properly write the new files when changes are made
  ///

  Registry _registry = Registry(appName: 'newApp', registeredClasses: []);

  Future loadRegistries() async {
    // var builderRegistryJsonString = await sendReadRequest(Paths.builderRegistry);
    var json = await sendReadRequest(Paths.dataClassesRegistry);
    print(json);
    // _registry = Registry.fromJson(jsonDecode(builderRegistryJsonString));
    // _registry = Registry.fromJson(jsonDecode(json));
    // loadClassesIntoMapFromRegistry();
    // notifyListeners();
  }

  /// IO SCREEN REBUILD
  String _rebuiltMessage = "";

  String get rebuiltMessage => _rebuiltMessage;
}

void printFieldDatas(ClassData classData) {
  print("~~~~~~~~~~~~~~");
  print("Field Data for ${classData.name}:");
  for (var f in classData.fieldData) {
    print(
        "    Name: ${f.name}, Type: ${f.type}, IsAList: ${f.isAList}, IsAClass: ${f.isAClass}");
  }
  print("~~~~~~~~~~~~~~\n");
}

/// Writing to file! Uhuuu!

// Future updateBuilderRegistry() async {
//   var fileToWrite = FileToWrite(name: '', fileLocation: Paths.builderRegistry, code: jsonEncode(_builderRegistry.toMap()));
//   return await sendWriteRequest(fileToWrite);
// }
// void registerNewClassForBuilder(ClassData classData) {
//   _builderRegistry = Registry(appName: _builderRegistry.appName, registeredClasses: [
//     ..._builderRegistry.registeredClasses,
//     ClassRegister(classData: classData, dateModified: DateTime.now().toString(), isMainRequest: false),
//   ]);
//   updateBuilderRegistry();
// }
///
