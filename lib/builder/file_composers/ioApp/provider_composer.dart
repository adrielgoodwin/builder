import '../../models/class_data.dart';
import '../../extensions.dart';

String composeProvider(List<ClassData> classDatas) {

  var c = classDatas;

  List<String> components = [];

  var imports = c.map((e) => "import '../data-classes/${e.name}.dart';").toList().join('\n');

  /// Imports
  components.add("""import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../../write_files_api.dart';
$imports \n""");

  /// Provider name or whatevs
  components.add("class MainProvider with ChangeNotifier {\n\n");

  /// Database stuff
  var db = "  Map<String, Map<String, dynamic>> db = {\n";
  db += classDatas.map((e) => '    "${e.name}s": {},\n').toList().join();
  db += "  };\n\n";
  components.add(db);

  var loadDb = """ 
  Future loadDB() async {
    String jasonResponse = await sendReadRequest(Paths.database);
    Map<String, dynamic> map = json.decode(jasonResponse); 
    db = map.map((key, value) => MapEntry(key, value as Map<String, dynamic>)); 
""";
  loadDb += classDatas.map((e) => '    load${e.name}s(map["${e.name}s"]);\n').toList().join();
  loadDb += "  }\n\n";
  components.add(loadDb);

  var writeDB = """ 
  Future writeDB() async {
    var ftw = FileToWrite(name: "", fileLocation: Paths.database, code: json.encode(db));
    await sendWriteRequest(ftw);
  }\n\n""";
  components.add(writeDB);

  var cruds = c.map((e) => makeCrud(e)).toList().join();

  /// CRUD
  components.add(cruds);

  components.add("}");

  return components.join();
}

String makeCrud(ClassData c) {
  var Cn = c.name;
  var Cns = Cn + "s";
  var cn = c.name.paramify();
  var cns = cn + "s";
  return """
  ///_____________________________
  /// $Cn 
  
  Map<String, $Cn> _$cns = {};

  List<$Cn> get get$Cns => _$cns.values.toList();

  $Cn get$Cn(String name) => _$cns[name]!;

  List<$Cn> get${Cns}ByName(String string) {
    return _$cns.values.where(($cn) => $cn.name.substring(0, string.length) == string).toList();
  }
  
  List<$Cn> get${Cns}ListByNameList(List<String> names) {
    return get$Cns.where((element) => names.contains(element.name)).toList();
  }

  void add$Cn($Cn $cn) {
    _$cns.addAll({$cn.name: $cn});
    notifyListeners();
    Map<String, Map<String, dynamic>> items = {};
    _$cns.forEach((key, value) {
      items.addAll({key: value.toMap()});
    });
    db["$Cns"] = items;
    writeDB();
  }
  
  void load$Cns(Map<String, dynamic> map) {
    var newMap = map.map((key, value) => MapEntry(key, $Cn.fromJson(value as Map<String, dynamic>)));
    _$cns = newMap;
    notifyListeners();
  }

  void remove$Cns($Cn $cn) {
    _$cns.remove($cn.name);
    notifyListeners();
  }  
  
 """;
}
