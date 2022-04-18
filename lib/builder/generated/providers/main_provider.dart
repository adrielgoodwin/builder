import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../../write_files_api.dart';
import '../data-classes/NewClassy.dart'; 
class MainProvider with ChangeNotifier {

  Map<String, Map<String, dynamic>> db = {
    "NewClassys": {},
  };

  Future loadDB() async {
    String jasonResponse = await sendReadRequest(Paths.database);
    Map<String, dynamic> map = json.decode(jasonResponse); 
    db = map.map((key, value) => MapEntry(key, value as Map<String, dynamic>)); 
    loadNewClassys(map["NewClassys"]);
  }

  Future writeDB() async {
    var ftw = FileToWrite(name: "", fileLocation: Paths.database, code: json.encode(db));
    await sendWriteRequest(ftw);
  }

  ///_____________________________
  /// NewClassy 
  
  Map<String, NewClassy> _newClassys = {};

  List<NewClassy> get getNewClassys => _newClassys.values.toList();

  NewClassy getNewClassy(String name) => _newClassys[name]!;

  List<NewClassy> getNewClassysByName(String string) {
    return _newClassys.values.where((newClassy) => newClassy.name.substring(0, string.length) == string).toList();
  }
  
  List<NewClassy> getNewClassysListByNameList(List<String> names) {
    return getNewClassys.where((element) => names.contains(element.name)).toList();
  }

  void addNewClassy(NewClassy newClassy) {
    _newClassys.addAll({newClassy.name: newClassy});
    notifyListeners();
    Map<String, Map<String, dynamic>> items = {};
    _newClassys.forEach((key, value) {
      items.addAll({key: value.toMap()});
    });
    db["NewClassys"] = items;
    writeDB();
  }
  
  void loadNewClassys(Map<String, dynamic> map) {
    var newMap = map.map((key, value) => MapEntry(key, NewClassy.fromJson(value as Map<String, dynamic>)));
    _newClassys = newMap;
    notifyListeners();
  }

  void removeNewClassys(NewClassy newClassy) {
    _newClassys.remove(newClassy.name);
    notifyListeners();
  }  
  
 }