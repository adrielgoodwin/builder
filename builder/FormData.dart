// ignore_for_file: file_names

import "FormFieldData.dart";
// This code was generated on 2021-09-22 11:00
// class
class FormData {
  // fields
  String className;
  List<FormFieldData> formFieldData;
  // fields end
  FormData({required this.className, required this.formFieldData});
  factory FormData.fromJson(Map<String, dynamic> data) {
    var formFieldDataList = data['formFieldData'];
    List<FormFieldData> listOfFormFieldData = [];
    for(var i = 0; i < formFieldDataList.length; i++){
      listOfFormFieldData.add(FormFieldData.fromJson(formFieldDataList[i]));
    }
    return FormData(
      className: data['className'],
      formFieldData: listOfFormFieldData,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'formFieldData': formFieldData.map((e) => e.toMap()).toList(),
    };
  }
  static FormData makeWithData(List<String> iterations) {
   return FormData(
     className: "FormData className",
     formFieldData: FormFieldData.makeMultipleWithData(iterations),
  );
  }
  static List<FormData> makeMultipleWithData(List<String> iterations) {
    List<FormData> formDataList = [];
      iterations.forEach((x) {
        formDataList.add(FormData(
        className: "FormData className",
        formFieldData: FormFieldData.makeMultipleWithData(iterations),
      ));
    });
   return formDataList;
  }
}
