import '../../models/nameValueType.dart';

// This code was generated on 2022-04-07 23:56
// class
class InventoryItem {
  // fields
  final String name;
  final int amount;
  final String id;
  // fields end
  InventoryItem({required this.name, required this.amount, required this.id});
  factory InventoryItem.fromJson(Map<String, dynamic> data) {
    return InventoryItem(
      name: data['name'],
      amount: data['amount'],
      id: data['id'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'id': id,
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String'),

      NameValueType('amount', amount, 'int'),

      NameValueType('id', id, 'String'),

  ];
  static InventoryItem makeWithData(List<String> iterations) {
   return InventoryItem(
     name: "InventoryItem name",
     amount: 3322,
     id: "InventoryItem id",
  );
  }
  static List<InventoryItem> makeMultipleWithData(List<String> iterations) {
    List<InventoryItem> inventoryItemList = [];
      iterations.forEach((x) {
        inventoryItemList.add(InventoryItem(
        name: "InventoryItem name",
        amount: 3322,
        id: "InventoryItem id",
      ));
    });
   return inventoryItemList;
  }
}