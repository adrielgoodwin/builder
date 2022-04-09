import 'dart:convert';

import 'package:http/http.dart' as http;

class Endpoints {
  static var writeFile = Uri.parse('http://localhost:5000/writeFile');
  static var readFile = Uri.parse('http://localhost:5000/readFile');
  static var cleanDir = Uri.parse('http://localhost:8001/cleanDirectory');
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
}

class NewProjectPaths {
  static const newProjectName = 'another_flutter_app';
  static const root = "$newProjectName/lib";
  static const models = "$root/app/models/";
  static const pages = "$root/app/pages/";
  static const widgets = "$root/app/widgets/";
  static const appRoot = "$newProjectName/app/";
}

class FileToWrite {
  FileToWrite({required this.name, required this.fileLocation, required this.code});

  final String name;
  final String fileLocation;
  final String code;

  Map<String, String> toMap() {
    return {
      "name": name,
      "path": fileLocation,
      "code": code,
    };
  }
}

Future sendCleanDirectoryRequest(List<String> goodFiles) async {
  await http.post(Endpoints.cleanDir, body: jsonEncode({"goodFiles": goodFiles}));
}

Future<bool> sendWriteRequest(FileToWrite fileToWrite) async {
  var pathNCode = {
    'path': fileToWrite.fileLocation + fileToWrite.name,
    'code': fileToWrite.code,
    'password': 'whoobilybhoobily',
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
  return response.body;
}
