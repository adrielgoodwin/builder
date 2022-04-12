import '../../models/nameValueType.dart';

import "InventoryItem.dart";
// This code was generated on 2022-04-12 11:46
// class
class Thingy {
  // fields
  final String name;
  final InventoryItem inventoryItem;
  // fields end
  Thingy({required this.name, required this.inventoryItem});
  factory Thingy.fromJson(Map<String, dynamic> data) {
    return Thingy(
      name: data['name'],
      inventoryItem: InventoryItem.fromJson(data['inventoryItem']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'inventoryItem': inventoryItem.toMap(),
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String', false, false), 

      NameValueType('inventoryItem', inventoryItem.name, 'String', false, true), 

  ];
  static Thingy makeWithData(List<String> iterations) {
   return Thingy(
     name: "Thingy name",
     inventoryItem: InventoryItem.makeWithData(iterations),
  );
  }
  static List<Thingy> makeMultipleWithData(List<String> iterations) {
    List<Thingy> thingyList = [];
      iterations.forEach((x) {
        thingyList.add(Thingy(
        name: "Thingy name",
        inventoryItem: InventoryItem.makeWithData(iterations),
      ));
    });
   return thingyList;
  }
}