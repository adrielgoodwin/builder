// This code was generated on 2021-09-22 11:00
// class
// ignore_for_file: file_names

class FormFieldData {
  // fields
  String name;
  String label;
  String placeHolder;
  String dataType;
  String constraints;
  String size;
  bool multiLine;
  // fields end
  FormFieldData({required this.name, required this.label, required this.placeHolder, required this.dataType, required this.constraints, required this.size, required this.multiLine});
  factory FormFieldData.fromJson(Map<String, dynamic> data) {
    return FormFieldData(
      name: data['name'],
      label: data['label'],
      placeHolder: data['placeHolder'],
      dataType: data['dataType'],
      constraints: data['constraints'],
      size: data['size'],
      multiLine: data['multiLine'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'label': label,
      'placeHolder': placeHolder,
      'dataType': dataType,
      'constraints': constraints,
      'size': size,
      'multiLine': multiLine,
    };
  }
  static FormFieldData makeWithData(List<String> iterations) {
   return FormFieldData(
     name: "FormFieldData name",
     label: "FormFieldData label",
     placeHolder: "FormFieldData placeHolder",
     dataType: "FormFieldData dataType",
     constraints: "FormFieldData constraints",
     size: "FormFieldData size",
     multiLine: true,
  );
  }
  static List<FormFieldData> makeMultipleWithData(List<String> iterations) {
    List<FormFieldData> formFieldDataList = [];
      iterations.forEach((x) {
        formFieldDataList.add(FormFieldData(
        name: "FormFieldData name",
        label: "FormFieldData label",
        placeHolder: "FormFieldData placeHolder",
        dataType: "FormFieldData dataType",
        constraints: "FormFieldData constraints",
        size: "FormFieldData size",
        multiLine: true,
      ));
    });
   return formFieldDataList;
  }
}
