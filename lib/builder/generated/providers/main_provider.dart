import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../../write_files_api.dart';
import '../data-classes/InventoryItem.dart';
import '../data-classes/Thingy.dart';
import '../data-classes/Thangy.dart'; 
class MainProvider with ChangeNotifier {

  Map<String, Map<String, dynamic>> db = {
    "InventoryItems": {},
    "Thingys": {},
    "Thangys": {},
  };

  Future loadDB() async {
    String jasonResponse = await sendReadRequest(Paths.database);
    Map<String, dynamic> map = json.decode(jasonResponse); 
    db = map.map((key, value) => MapEntry(key, value as Map<String, dynamic>)); 
    loadInventoryItems(map["InventoryItems"]);
    loadThingys(map["Thingys"]);
    loadThangys(map["Thangys"]);
  }

  Future writeDB() async {
    var ftw = FileToWrite(name: "", fileLocation: Paths.database, code: json.encode(db));
    await sendWriteRequest(ftw);
  }

  ///_____________________________
  /// InventoryItem 
  
  Map<String, InventoryItem> _inventoryItems = {};

  List<InventoryItem> get getInventoryItems => _inventoryItems.values.toList();

  InventoryItem getInventoryItem(String name) => _inventoryItems[name]!;

  List<InventoryItem> getInventoryItemsByName(String string) {
    return _inventoryItems.values.where((inventoryItem) => inventoryItem.name.substring(0, string.length) == string).toList();
  }
  
  List<InventoryItem> getInventoryItemsListByNameList(List<String> names) {
    return getInventoryItems.where((element) => names.contains(element.name)).toList();
  }

  void addInventoryItem(InventoryItem inventoryItem) {
    _inventoryItems.addAll({inventoryItem.name: inventoryItem});
    notifyListeners();
    Map<String, Map<String, dynamic>> items = {};
    _inventoryItems.forEach((key, value) {
      items.addAll({key: value.toMap()});
    });
    db["InventoryItems"] = items;
    writeDB();
  }
  
  void loadInventoryItems(Map<String, dynamic> map) {
    var newMap = map.map((key, value) => MapEntry(key, InventoryItem.fromJson(value as Map<String, dynamic>)));
    _inventoryItems = newMap;
    notifyListeners();
  }

  void removeInventoryItems(InventoryItem inventoryItem) {
    _inventoryItems.remove(inventoryItem.name);
    notifyListeners();
  }  
  
   ///_____________________________
  /// Thingy 
  
  Map<String, Thingy> _thingys = {};

  List<Thingy> get getThingys => _thingys.values.toList();

  Thingy getThingy(String name) => _thingys[name]!;

  List<Thingy> getThingysByName(String string) {
    return _thingys.values.where((thingy) => thingy.name.substring(0, string.length) == string).toList();
  }
  
  List<Thingy> getThingysListByNameList(List<String> names) {
    return getThingys.where((element) => names.contains(element.name)).toList();
  }

  void addThingy(Thingy thingy) {
    _thingys.addAll({thingy.name: thingy});
    notifyListeners();
    Map<String, Map<String, dynamic>> items = {};
    _thingys.forEach((key, value) {
      items.addAll({key: value.toMap()});
    });
    db["Thingys"] = items;
    writeDB();
  }
  
  void loadThingys(Map<String, dynamic> map) {
    var newMap = map.map((key, value) => MapEntry(key, Thingy.fromJson(value as Map<String, dynamic>)));
    _thingys = newMap;
    notifyListeners();
  }

  void removeThingys(Thingy thingy) {
    _thingys.remove(thingy.name);
    notifyListeners();
  }  
  
   ///_____________________________
  /// Thangy 
  
  Map<String, Thangy> _thangys = {};

  List<Thangy> get getThangys => _thangys.values.toList();

  Thangy getThangy(String name) => _thangys[name]!;

  List<Thangy> getThangysByName(String string) {
    return _thangys.values.where((thangy) => thangy.name.substring(0, string.length) == string).toList();
  }
  
  List<Thangy> getThangysListByNameList(List<String> names) {
    return getThangys.where((element) => names.contains(element.name)).toList();
  }

  void addThangy(Thangy thangy) {
    _thangys.addAll({thangy.name: thangy});
    notifyListeners();
    Map<String, Map<String, dynamic>> items = {};
    _thangys.forEach((key, value) {
      items.addAll({key: value.toMap()});
    });
    db["Thangys"] = items;
    writeDB();
  }
  
  void loadThangys(Map<String, dynamic> map) {
    var newMap = map.map((key, value) => MapEntry(key, Thangy.fromJson(value as Map<String, dynamic>)));
    _thangys = newMap;
    notifyListeners();
  }

  void removeThangys(Thangy thangy) {
    _thangys.remove(thangy.name);
    notifyListeners();
  }  
  
 }