import "FieldData.dart";
// This code was generated on 2021-09-03 12:13
// class
class ClassData {
  // fields
  String name;
  // if this is not null, then this class is a direct db item
  // DBItemMetadata? dbMetadata;
  List<FieldData> fieldData;
  List<String> neededImports;
  // fields end
  ClassData({required this.name, required this.fieldData, required this.neededImports});
  factory ClassData.fromJson(Map<String, dynamic> data) {
    var fieldDataList = data['fieldData'];
    List<FieldData> listOfFieldData = [];
    for(var i = 0; i < fieldDataList.length; i++){
      listOfFieldData.add(FieldData.fromJson(fieldDataList[i]));
    }
    return ClassData(
      name: data['name'],
      fieldData: listOfFieldData,
      neededImports: data['neededImports'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fieldData': fieldData.map((e) => e.toMap()).toList(),
      'neededImports': neededImports,
    };
  }
}
