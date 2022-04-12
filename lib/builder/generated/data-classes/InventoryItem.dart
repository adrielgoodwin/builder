import '../../models/nameValueType.dart';

// This code was generated on 2022-04-12 11:46
// class
class InventoryItem {
  // fields
  final String name;
  final String unit;
  // fields end
  InventoryItem({required this.name, required this.unit});
  factory InventoryItem.fromJson(Map<String, dynamic> data) {
    return InventoryItem(
      name: data['name'],
      unit: data['unit'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'unit': unit,
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String', false, false), 

      NameValueType('unit', unit, 'String', false, false), 

  ];
  static InventoryItem makeWithData(List<String> iterations) {
   return InventoryItem(
     name: "InventoryItem name",
     unit: "InventoryItem unit",
  );
  }
  static List<InventoryItem> makeMultipleWithData(List<String> iterations) {
    List<InventoryItem> inventoryItemList = [];
      iterations.forEach((x) {
        inventoryItemList.add(InventoryItem(
        name: "InventoryItem name",
        unit: "InventoryItem unit",
      ));
    });
   return inventoryItemList;
  }
}