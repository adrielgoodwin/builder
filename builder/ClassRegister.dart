// ignore_for_file: file_names

import "ClassData.dart";
// This code was generated on 2021-09-03 12:13
// class
class ClassRegister {
  // fields
  final ClassData classData;
  final String dateModified;
  final bool isMainRequest;
  // fields end
  ClassRegister({required this.classData, required this.dateModified, required this.isMainRequest});
  factory ClassRegister.fromJson(Map<String, dynamic> data) {
    return ClassRegister(
      classData: ClassData.fromJson(data['classData']),
      dateModified: data['dateModified'],
      isMainRequest: data['isMainRequest'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'classData': classData.toMap(),
      'dateModified': dateModified,
      'isMainRequest': isMainRequest,
    };
  }
}
