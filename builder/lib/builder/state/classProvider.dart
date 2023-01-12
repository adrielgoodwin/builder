import '../file_composers/composerFunctions.dart' as composer;
import 'package:flutter/material.dart';
// models
import '../models/registry.dart';
import '../models/class_register.dart';
import '../models/class_data.dart';

// This whole registry thing could be better

class ClassProvider with ChangeNotifier {
  
  ClassProvider(this.registry);
  
  Registry registry;

  List<ClassData> get classes => registry.registeredClasses.map((e) => e.classData).toList();
  
  void addClass(ClassData classData) {
    registry.registeredClasses = [...registry.registeredClasses, ClassRegister(classData: classData, dateModified: DateTime.now().toString())];
    saveAndNotify();
  }
  
  void updateClass(ClassData classData) {
    var index = registry.registeredClasses.indexWhere((element) => element.classData.id == classData.id);
    registry.registeredClasses.replaceRange(index, index+1, [ClassRegister(classData: classData, dateModified: DateTime.now().toString())]);
    saveAndNotify();
  }
  
  void deleteClass(ClassData classData) {
    registry.registeredClasses.removeWhere((element) => element.classData.id == classData.id);
    composer.deleteClass(classData);
    saveAndNotify();
  }

  bool nameInUse(String name) => registry.registeredClasses.indexWhere((element) => element.classData.name == name) >= 0 ? true : false;
  
  void saveAndNotify() {
    printRegistry(registry);
    // composer.writeRegistry(registry);
    notifyListeners();
  }
  
}

void printFieldDatas(ClassData classData) {
  print("        Field Data for ${classData.name}:");
  for (var f in classData.fieldData) {
    print(
        "            Name: ${f.name}, Type: ${f.type}, IsAList: ${f.isAList}, IsAClass: ${f.isAClass}");
  }
}

void printRegistry(Registry registry, { bool printFields = true}) {
  print("`````````````` Registry ``````````````");
  registry.registeredClasses.forEach((element) {
    print("    ${element.classData.name}");
    if(printFields) {
      printFieldDatas(element.classData);
    }
  });
}