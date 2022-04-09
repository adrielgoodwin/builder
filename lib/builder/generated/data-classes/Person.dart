import '../../models/nameValueType.dart';

// This code was generated on 2022-04-08 18:48
// class
class Person {
  // fields
  final String name;
  final int age;
  final String id;
  // fields end
  Person({required this.name, required this.age, required this.id});
  factory Person.fromJson(Map<String, dynamic> data) {
    return Person(
      name: data['name'],
      age: data['age'],
      id: data['id'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'id': id,
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String'),

      NameValueType('age', age, 'int'),

      NameValueType('id', id, 'String'),

  ];
  static Person makeWithData(List<String> iterations) {
   return Person(
     name: "Person name",
     age: 3322,
     id: "Person id",
  );
  }
  static List<Person> makeMultipleWithData(List<String> iterations) {
    List<Person> personList = [];
      iterations.forEach((x) {
        personList.add(Person(
        name: "Person name",
        age: 3322,
        id: "Person id",
      ));
    });
   return personList;
  }
}