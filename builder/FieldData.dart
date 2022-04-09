// This code was generated on 2021-09-03 12:13
// class
// ignore_for_file: file_names

class FieldData {
  // fields
  String type;
  String name;
  bool isAClass;
  bool isAList;
  // fields end
  FieldData({required this.type, required this.name, required this.isAClass, required this.isAList});
  factory FieldData.fromJson(Map<String, dynamic> data) {
    return FieldData(
      type: data['type'],
      name: data['name'],
      isAClass: data['isAClass'],
      isAList: data['isAList'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'isAClass': isAClass,
      'isAList': isAList,
    };
  }
}
