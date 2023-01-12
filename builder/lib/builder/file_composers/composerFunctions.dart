// models
import 'dart:convert';

import '../models/class_data.dart';
import '../models/class_register.dart';
import '../models/registry.dart';

// composers
import 'data_class_composer.dart';

// io app composers
import 'ioApp/form_composer.dart';
import 'ioApp/records_composer.dart';
import 'ioApp/main_screen_composer.dart';
import 'ioApp/provider_composer.dart';

// write request api
import '../write_files_api.dart';

Future<bool> writeClass(ClassData classData) async {
  List<String> neededImports = [];
  for (var field in classData.fieldData) {
    if (field.isAClass) neededImports = [...neededImports, field.type];
  }
  classData.neededImports = neededImports;
  var code = DataClassComposer().composeFromClassData(classData);
  var path = [Paths.dataClasses, classData.name, ".dart"].join();
  return await sendWriteRequest(path: path, code: code);
}

Future writeRegistry(Registry registry) async {
  var code = jsonEncode(registry.toMap());
  return await sendWriteRequest(path: Paths.registry, code: code);
}

Future writeForm(ClassData classData) async {
  var formCode = composeForm(classData);
  var path = [Paths.ioForms, classData.name, "Form.dart"].join();
  return await sendWriteRequest(path: path, code: formCode);
}

Future writeRecordScreen(ClassData classData) async {
  var recordScreenCode = composeRecordsPage(classData);
  var path = [Paths.ioRecordDisplays, classData.name, "Records.dart"].join();
  return await sendWriteRequest(path: path, code: recordScreenCode);
}

Future writeProvider(List<ClassData> classDatas) async {
  var providerCode = composeProvider(classDatas);
  var path = [Paths.provider, "main_provider.dart"].join();
  return await sendWriteRequest(path: path, code: providerCode);
}

Future writeIOAppScreen(List<ClassData> classDatas) async {
  var ioAppScreenCode = composeMainIOAppScreen(classDatas);
  var path = [Paths.ioAppScreen, ioAppScreenCode].join();
  return await sendWriteRequest(path: path, code: ioAppScreenCode);
}

Future deleteClass(ClassData classData) async {
  await sendDeleteRequest(Paths.dataClasses + classData.name + '.dart');
}

Future deleteForm(ClassData classData) async {
  await sendDeleteRequest(Paths.ioForms + classData.name + 'Form.dart');
}

Future deleteRecordPage(ClassData classData) async {
  await sendDeleteRequest(Paths.ioRecordDisplays + classData.name + 'Records.dart');
}













