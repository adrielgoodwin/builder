// ignore: slash_for_doc_comments
/**

    This will help me to build flutter applications by generating BASIC CODE

    from a class with some properties, generate;
    constructor function,
    constructor from.Json
    a ToJson function
    a starter stful and stless widget
    a provider


    how to do it:
    Read all files within a models folder.
    Store all class names in local list.
    Find where a class contains another class inside of it, taking note if its singular or a list
    create proper functions for that class

 **/

import 'dart:convert' show jsonEncode;
import 'dart:io';
import 'FieldData.dart';
import 'Registry.dart';
import 'ClassData.dart';
import 'ClassRegister.dart';
import 'ClassFileComponents.dart';

// TODO ~ write example json requests/responses
// TODO ~ implement provider code
// TODO ~ extra - implement page starters. Start a page by first selecting required datas

const MODELS_PATH = "../lib/models/";

ClassData getClassData(String fileName, String dirPath) {
  String filePath = "";
  if (dirPath != "") filePath = dirPath;
  // get each line of the file
  List<String> lines = new File("$filePath$fileName.dart").readAsLinesSync();

  // get the class name
  int classNameIndex = lines.indexWhere((element) => element == "// class") + 1;
  String classNameLine = lines[classNameIndex];
  String className = classNameLine.substring(5, classNameLine.indexOf("{")).trim();

  // determine start/finish index of fields
  int fieldsStart = lines.indexWhere((e) => e == "  // fields") + 1;
  int fieldsEnd = lines.indexWhere((e) => e == "  // fields end");

  // instantiate field data of current class
  List<FieldData> fieldDatas = [];

  // instantiate imports of current class
  List<String> neededImports = [];

  // iterate over fields, instantiate as field data and add to list
  for (var i = fieldsStart; i < fieldsEnd; i++) {
    // extract type and name
    List<String> fieldDataStrings = lines[i].trim().split(" ");
    String fieldType = fieldDataStrings[0];
    String fieldName = fieldDataStrings[1];
    bool isAList = fieldType.startsWith('List');
    // first check to see if its a list
    if (isAList) {
      // if its a list, 'List<Class>' remove List = '<Class>', then substring taking off the '<>'
      fieldType = fieldType.replaceAll("List", "").substring(1).replaceAll(">", "");
    }
    // properly check if its a class
    bool isAClass = !['int', 'String', 'double', 'bool'].contains(fieldType);

    // add imports
    if (isAClass) neededImports.add(fieldType);

    fieldDatas.add(FieldData(
      type: fieldType.trim(),
      name: fieldName.replaceAll(";", "").trim(),
      isAClass: isAClass,
      isAList: isAList,
    ));
  }

  return ClassData(name: className, fieldData: fieldDatas, neededImports: neededImports);
}

void recordInRegistry(Registry registry) {
  File registryFile = File('class_registry.json');
  Map<String, dynamic> registryMap = registry.toMap();
  registryFile.writeAsString(jsonEncode(registryMap));
}

void generateClassFilesFromListOfNames(List<String> classes, String pathToFiles) {
  List<ClassRegister> classRegisterList = [];
  classes.forEach((classFileName) {
    ClassFileComponents classFile = ClassFileComponents(getClassData(classFileName, pathToFiles));
    classFile.go();
    classFile.writeToFile(pathToFiles);
    classRegisterList.add(classFile.instantiateClassRegister());
  });
  var registry = Registry(appName: "happening", registeredClasses: classRegisterList);
  recordInRegistry(registry);
}

void generateClassFilesFromClassData(ClassData classData, String dirPath) {
  ClassFileComponents classFile = ClassFileComponents(classData);
  classFile.go();
  classFile.writeToFile(dirPath);
  // List<ClassRegister> classRegisterList = [];
  // classRegisterList.add(classFile.instantiateClassRegister());
}

void generateTestJson(Registry registry) {
  // Loop over all registered classes
  registry.registeredClasses.forEach((classRegister) {
    // Loop over all fields of class
    classRegister.classData.fieldData.forEach((fieldData) {
      // Get field type,
    });
  });
}

main() {
  // generateClassFilesFromListOfNames(['ClassData', 'ClassRegister', 'FieldData', 'Registry'], "");
  generateClassFilesFromListOfNames(['FormFieldData', 'FormData'], "");
}
