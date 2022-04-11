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

class ClassMakerProvider with ChangeNotifier {
  bool _isForBuilder = false;

  void setIsClassForBuilder(bool boolean) => _isForBuilder = boolean;

  bool get isForBuilder => _isForBuilder;

  ///
  /// ClassData map
  /// This is the 'working memory spot' for adding or updating classes
  ///

  Map<String, ClassData> _newAppClassesMap = {};
  Map<String, ClassData> _builderClassesMap = {};

  List<ClassData> get newAppClasses => _newAppClassesMap.values.toList();

  List<ClassData> get builderClasses => _builderClassesMap.values.toList();

  String addNewClass(ClassData classData) {
    if (_newAppClassesMap.containsKey(classData.name)) {
      return "Already Exists";
    } else {
      _newAppClassesMap.addAll({classData.id: classData});
      notifyListeners();
      return "Created new class ${classData.name}";
    }
  }

  String updateClass(ClassData classData) {
    _newAppClassesMap.update(classData.id, (value) => classData);
    notifyListeners();
    return "Updated ${classData.name}";
  }

  void deleteClass(ClassData classData) {
    _newAppClassesMap.remove(classData.id);
    notifyListeners();
  }

  void removeNewAppClass(ClassData classData) {
    if (_isForBuilder) {
      _builderClassesMap.remove(classData.name);
    } else {
      _newAppClassesMap.remove(classData.name);
    }
  }

  void loadClassesIntoMapFromRegistry() {
    for (var classRegister in _registry.registeredClasses) {
      _newAppClassesMap[classRegister.classData.id] = classRegister.classData;
    }
    // for (var classRegister in _builderRegistry.registeredClasses) {
    //   _builderClassesMap[classRegister.classData.id] = classRegister.classData;
    // }
    print(_newAppClassesMap.values.toList());

    notifyListeners();
  }

  ///
  /// Registries.
  /// These are the representation of the actual json file that stores the data for the classes.
  /// Only used as structured to properly write the new files when changes are made
  ///

  Registry _registry = Registry(appName: 'newApp', registeredClasses: []);
  Registry _builderRegistry =
      Registry(appName: 'builder', registeredClasses: []);

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

  void registerNewClassForNewApp(ClassData classData) {
    _registry = Registry(
      appName: _registry.appName,
      registeredClasses: [
        ..._registry.registeredClasses,
      ],
    );
  }

  void saveAndWriteFiles(ClassData newClassData) async {
    addNewClass(newClassData);
    for (var classData in newAppClasses) {
      await writeClass(classData);
      await writeForm(classData);
      await writeRecordScreen(classData);
    }
    await writeRegistry();
    await writeIOAppScreen(newAppClasses);
    await writeProvider(newAppClasses);
    _rebuiltMessage = "Rebuilt with ${newAppClasses.length} classes";
    notifyListeners();
  }



  Future writeRegistry() async {
    var registeredClasses = _newAppClassesMap.values
        .map((e) =>
            ClassRegister(classData: e, dateModified: '', isMainRequest: false))
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
    var ioAppScreenCode = composeMainIOAppScreen(newAppClasses);
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
