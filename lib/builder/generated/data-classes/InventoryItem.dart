import '../../models/nameValueType.dart';

import "Unit.dart";
// This code was generated on 2022-04-11 18:48
// class
class InventoryItem {
  // fields
  final String name;
  final int price;
  final Unit unit;
  // fields end
  InventoryItem({required this.name, required this.price, required this.unit});
  factory InventoryItem.fromJson(Map<String, dynamic> data) {
    return InventoryItem(
      name: data['name'],
      price: data['price'],
      unit: Unit.fromJson(data['unit']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'unit': unit.toMap(),
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String', false, false), 

      NameValueType('price', price, 'int', false, false), 

      NameValueType('unit', unit.name, 'String', false, true), 

  ];
  static InventoryItem makeWithData(List<String> iterations) {
   return InventoryItem(
     name: "InventoryItem name",
     price: 3322,
     unit: Unit.makeWithData(iterations),
  );
  }
  static List<InventoryItem> makeMultipleWithData(List<String> iterations) {
    List<InventoryItem> inventoryItemList = [];
      iterations.forEach((x) {
        inventoryItemList.add(InventoryItem(
        name: "InventoryItem name",
        price: 3322,
        unit: Unit.makeWithData(iterations),
      ));
    });
   return inventoryItemList;
  }
}