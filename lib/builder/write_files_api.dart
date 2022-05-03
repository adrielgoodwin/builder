import 'dart:convert';

import 'package:http/http.dart' as http;

class Endpoints {
  static var writeFile = Uri.parse('http://localhost:5000/writeFile');
  static var readFile = Uri.parse('http://localhost:5000/readFile');
  static var deleteFile = Uri.parse('http://localhost:5000/deleteFile');
}

class Paths {
  static const widgets = 'lib/builder/generated/widgets/';
  static const dataClasses = 'lib/builder/generated/data-classes/';
  static const provider = 'lib/builder/generated/providers/';
  static const dataClassesRegistry = 'lib/builder/generated/data-classes/registry/registry.json';
  static const builderClasses = 'lib/builder/models/';
  static const builderRegistry = 'lib/builder/models/registry/registry.json';
  static const ioForms = 'lib/builder/generated/forms/';
  static const ioRecordDisplays = 'lib/builder/generated/record_displays/';
  static const ioAppScreen = 'lib/builder/generated/io_app/';
  static const database = 'lib/builder/generated/io_app/database.json';
}

class NewProjectPaths {
  static const newProjectName = 'another_flutter_app';
  static const root = "$newProjectName/lib";
  static const models = "$root/app/models/";
  static const pages = "$root/app/pages/";
  static const widgets = "$root/app/widgets/";
  static const appRoot = "$newProjectName/app/";
}

Future sendDeleteRequest(String path) async {
  var pathNPass = {
    'password': 'whoobilybhoobily',
    'path': path,
  };
  var response = await http.post(Endpoints.deleteFile, body: json.encode(pathNPass), headers: {'content-type': 'application/json'});
}

Future<bool> sendWriteRequest({required String path, required String code}) async {
  var pathNCode = {
    'path': path,
    'code': code,
  };
  var response = await http.post(Endpoints.writeFile, body: json.encode(pathNCode), headers: {'content-type': 'application/json'});

  return response.statusCode == 200 ? true : false;
}

Future<String> sendReadRequest(String path) async {
  var response = await http.post(Endpoints.readFile, body: json.encode(
      {'password': 'whoobilybhoobily', 'path': path},
  ), headers: {'content-type': 'application/json'});
  // Map<String, dynamic> jsonMap = jsonDecode(response.body);
  // return jsonMap['code'];
  print(response.body);
  return response.body;
}
