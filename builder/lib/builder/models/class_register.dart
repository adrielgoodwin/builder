// ignore_for_file: file_names

import "class_data.dart";
// This code was generated on 2021-09-03 12:13
// class
class ClassRegister {
  // fields
  final ClassData classData;
  // todo: date(s) modified with a modification note
  // todo: add a description
  // final String description
  final String dateModified;
  // fields end
  ClassRegister({required this.classData, required this.dateModified});
  factory ClassRegister.fromJson(Map<String, dynamic> data) {
    return ClassRegister(
      classData: ClassData.fromJson(data['classData']),
      dateModified: data['dateModified'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'classData': classData.toMap(),
      'dateModified': dateModified,
    };
  }
}
