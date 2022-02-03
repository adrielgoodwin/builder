import 'dart:convert';

import 'package:http/http.dart' as http;

class Endpoints {
  static var writeFile = Uri.parse('http://localhost:8001/writeFile');
  static var readFile = Uri.parse('http://localhost:8001/readFile');
  static var cleanDir = Uri.parse('http://localhost:8001/cleanDirectory');
}

class Paths {
  static const widgets = 'lib/builder/generated/widgets/';
  static const dataClasses = 'lib/builder/generated/data_classes/';
  static const dataClassesRegistry = 'lib/builder/generated/data_classes/registry/registry.json';
  static const builderClasses = 'lib/builder/models/';
  static const builderRegistry = 'lib/builder/models/registry/registry.json';
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

class ReadRequest {
  final String path;
  ReadRequest({required this.path});

  Map<String, String> toMap() {
    return {
      "path": path,
    };
  }
}

Future sendCleanDirectoryRequest(List<String> goodFiles) async {
  await http.post(Endpoints.cleanDir, body: jsonEncode({"goodFiles": goodFiles}));
}

Future<bool> sendWriteRequest(FileToWrite fileToWrite) async {
  var response = await http.post(Endpoints.writeFile, body: json.encode(fileToWrite.toMap()));

  return response.statusCode == 200 ? true : false;
}

Future<String> sendReadRequest(ReadRequest readRequest) async {
  var response = await http.post(Endpoints.readFile, body: json.encode(readRequest.toMap()));
  Map<String, dynamic> jsonMap = jsonDecode(response.body);
  return jsonMap['code'];
}
