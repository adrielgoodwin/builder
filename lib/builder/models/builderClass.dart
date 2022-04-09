// This code was generated on 2022-01-29 11:26
// class
class builderClass {
  // fields
  final String builder;
  // fields end
  builderClass({required this.builder});
  factory builderClass.fromJson(Map<String, dynamic> data) {
    return builderClass(
      builder: data['builder'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'builder': builder,
    };
  }
  static builderClass makeWithData(List<String> iterations) {
   return builderClass(
     builder: "builderClass builder",
  );
  }
  static List<builderClass> makeMultipleWithData(List<String> iterations) {
    List<builderClass> builderClassList = [];
      iterations.forEach((x) {
        builderClassList.add(builderClass(
        builder: "builderClass builder",
      ));
    });
   return builderClassList;
  }
}