// This code was generated on 2021-09-03 12:13
// class
// ignore_for_file: file_names

class FieldData {
  // fields
  String parentClass;
  String id;
  String type;
  String name;
  String description;
  bool isAClass;
  bool isAList;
  // fields end
  FieldData({required this.parentClass, required this.type, required this.id, required this.name, required this.description, required this.isAClass, required this.isAList});
  factory FieldData.fromJson(Map<String, dynamic> data) {
    return FieldData(
      id: data['id'],
      parentClass: data['parentClass'],
      type: data['type'],
      name: data['name'],
      description: data['description'],
      isAClass: data['isAClass'],
      isAList: data['isAList'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentClass': parentClass,
      'type': type,
      'name': name,
      'description': description,
      'isAClass': isAClass,
      'isAList': isAList,
    };
  }
}
