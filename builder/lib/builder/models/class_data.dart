import "field_data.dart";
// This code was generated on 2021-09-03 12:13
// class
class ClassData {
  // fields
  String id;
  String name;
  List<FieldData> fieldData;
  List<String> neededImports;
  // fields end

  ClassData({this.name = "Person", required this.id, this.fieldData = const[], this.neededImports = const[]});
  factory ClassData.fromJson(Map<String, dynamic> data) {
    var fieldDataList = data['fieldData'];
    List<FieldData> listOfFieldData = [];
    for(var i = 0; i < fieldDataList.length; i++){
      listOfFieldData.add(FieldData.fromJson(fieldDataList[i]));
    }
    return ClassData(
      id: data['id'],
      name: data['name'],
      fieldData: listOfFieldData,
      neededImports: List<String>.from(data['neededImports']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fieldData': fieldData.map((e) => e.toMap()).toList(),
      'neededImports': neededImports,
    };
  }
}
