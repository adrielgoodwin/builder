// This code was generated on 2022-02-07 14:45
// class
class NewClass {
  // fields
  final String fieldOne;
  final String fieldTwo;
  // fields end
  NewClass({required this.fieldOne, required this.fieldTwo});
  factory NewClass.fromJson(Map<String, dynamic> data) {
    return NewClass(
      fieldOne: data['FieldOne'],
      fieldTwo: data['FieldTwo'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'FieldOne': fieldOne,
      'FieldTwo': fieldTwo,
    };
  }
  static NewClass makeWithData(List<String> iterations) {
   return NewClass(
     fieldOne: "NewClass fieldOne",
     fieldTwo: "NewClass fieldTwo",
  );
  }
  static List<NewClass> makeMultipleWithData(List<String> iterations) {
    List<NewClass> newClassList = [];
      iterations.forEach((x) {
        newClassList.add(NewClass(
        fieldOne: "NewClass fieldOne",
        fieldTwo: "NewClass fieldTwo",
      ));
    });
   return newClassList;
  }
}