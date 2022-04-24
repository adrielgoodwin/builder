import 'dart:convert';

import 'package:builder/builder/file_composers/ioApp/provider_composer.dart';
import 'package:builder/builder/models/builderClass.dart';
import '../file_composers/ioApp/main_screen_composer.dart';
import '../file_composers/ioApp/records_composer.dart';
import 'package:flutter/foundation.dart';
import '../models/class_data.dart';
import '../models/field_data.dart';
import '../models/class_register.dart';
import '../models/registry.dart';
import '../write_files_api.dart';
import '../file_composers/data_class_composer.dart';
import '../file_composers/ioApp/form_composer.dart';
import 'package:uuid/uuid.dart';

class ClassMakerProvider with ChangeNotifier {
  bool _isForBuilder = false;

  void setIsClassForBuilder(bool boolean) => _isForBuilder = boolean;

  bool get isForBuilder => _isForBuilder;

  var uuid = const Uuid();

  ///
  /// ClassData map
  /// This is the 'working memory spot' for adding or updating classes
  ///

  Map<String, ClassData> _existingClasses = {};

  Map<String, ClassData> _classesInCreation = {};

  List<ClassData> get classesInCreation => _classesInCreation.values.toList();

  void addBlankClass() {
    var id = uuid.v1();
    _classesInCreation.addAll({
      id: ClassData(name: 'NewClass', id: id, fieldData: [], neededImports: [])
    });
    notifyListeners();
  }

  List<ClassData> get existingClasses => _existingClasses.values.toList();

  String addNewClass(ClassData classData) {
    for (var c in _existingClasses.values) {
      if (c.name == classData.name) {
        return "Already Exists";
      }
    }
    printFieldDatas(classData);
    _existingClasses.addAll({classData.id: classData});
    _classesInCreation.remove(classData.id);
    notifyListeners();
    return "Created new class ${classData.name}";
  }

  String updateClass(ClassData classData) {
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
    writeRegistry();
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
    var dataClassesRegistryJsonString =
    await sendReadRequest(Paths.dataClassesRegistry);
    // _registry = Registry.fromJson(jsonDecode(builderRegistryJsonString));
    _registry = Registry.fromJson(jsonDecode(dataClassesRegistryJsonString));
    loadClassesIntoMapFromRegistry();
    notifyListeners();
  }

  Future updateNewAppRegistry() async {
    var fileToWrite = FileToWrite(
        name: '',
        fileLocation: Paths.dataClassesRegistry,
        code: jsonEncode(_registry.toMap()));
    return await sendWriteRequest(fileToWrite);
  }

  void saveAndWriteFiles(ClassData newClassData) async {
    addNewClass(newClassData);
    // for (var classData in existingClasses) {
    //   await writeClass(classData);
    //   await writeForm(classData);
    //   await writeRecordScreen(classData);
    // }
    // await writeRegistry();
    // await writeIOAppScreen(existingClasses);
    // await writeProvider(existingClasses);
    _rebuiltMessage = "Rebuilt with ${existingClasses.length} classes";
    notifyListeners();
  }

  Future writeRegistry(List<ClassData> classDatas) async {
    var registeredClasses = classDatas
        .map((e) =>
        ClassRegister(classData: e, dateModified: ''))
        .toList();
    var newRegistry = Registry(
        appName: _registry.appName, registeredClasses: registeredClasses);
    var ftw = FileToWrite(
      code: jsonEncode(newRegistry.toMap()),
      fileLocation: Paths.dataClassesRegistry,
      name: '',
    );
    await sendWriteRequest(ftw);
  }

  Future writeClass(ClassData classData) async {
    List<String> neededImports = [];
    for (var field in classData.fieldData) {
      if (field.isAClass) neededImports = [...neededImports, field.type];
    }
    classData.neededImports = neededImports;
    var ftw = FileToWrite(
      code: DataClassComposer().composeFromClassData(classData),
      fileLocation: Paths.dataClasses,
      name: classData.name + ".dart",
    );
    await sendWriteRequest(ftw);
  }

  Future writeForm(ClassData classData) async {
    var formCode = composeForm(classData);
    var ftw = FileToWrite(
        name: "${classData.name}Form.dart",
        fileLocation: Paths.ioForms,
        code: formCode);
    await sendWriteRequest(ftw);
  }

  Future writeRecordScreen(ClassData classData) async {
    var recordScreenCode = composeRecordsPage(classData);
    var ftw = FileToWrite(
        name: '${classData.name}Records.dart',
        fileLocation: Paths.ioRecordDisplays,
        code: recordScreenCode);
    await sendWriteRequest(ftw);
  }

  Future writeProvider(List<ClassData> classDatas) async {
    var providerCode = composeProvider(classDatas);
    var ftw = FileToWrite(
        name: 'main_provider.dart',
        fileLocation: Paths.provider,
        code: providerCode);
    await sendWriteRequest(ftw);
  }

  Future writeIOAppScreen(List<ClassData> classDatas) async {
    var ioAppScreenCode = composeMainIOAppScreen(classDatas);
    var ftw = FileToWrite(
        name: 'io_app_screen.dart',
        fileLocation: Paths.ioAppScreen,
        code: ioAppScreenCode);
    await sendWriteRequest(ftw);
  }

  /// IO SCREEN REBUILD
  String _rebuiltMessage = "";

  String get rebuiltMessage => _rebuiltMessage;
}

void printFieldDatas(ClassData classData) {
  print("~~~~~~~~~~~~~~");
  print("Field Data for ${classData.name}:");
  for(var f in classData.fieldData) {
    print("    Name: ${f.name}, Type: ${f.type}, IsAList: ${f.isAList}, IsAClass: ${f.isAClass}");
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
