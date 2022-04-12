import '../../models/nameValueType.dart';

import "Thingy.dart";
// This code was generated on 2022-04-12 11:46
// class
class Thangy {
  // fields
  final String name;
  final List<Thingy> thingies;
  // fields end
  Thangy({required this.name, required this.thingies});
  factory Thangy.fromJson(Map<String, dynamic> data) {
    var thingiesList = data['thingies'];
    List<Thingy> listOfThingy = [];
    for(var i = 0; i < thingiesList.length; i++){
      listOfThingy.add(Thingy.fromJson(thingiesList[i]));
    }
    return Thangy(
      name: data['name'],
      thingies: listOfThingy,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'thingies': thingies.map((e) => e.toMap()).toList(),
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String', false, false), 

      NameValueType('thingies', thingies.map((e) => '${e.name}').toList() , 'Thingy', true, true), 

  ];
  static Thangy makeWithData(List<String> iterations) {
   return Thangy(
     name: "Thangy name",
     thingies: Thingy.makeMultipleWithData(iterations),
  );
  }
  static List<Thangy> makeMultipleWithData(List<String> iterations) {
    List<Thangy> thangyList = [];
      iterations.forEach((x) {
        thangyList.add(Thangy(
        name: "Thangy name",
        thingies: Thingy.makeMultipleWithData(iterations),
      ));
    });
   return thangyList;
  }
}