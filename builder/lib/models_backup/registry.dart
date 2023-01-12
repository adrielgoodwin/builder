
import "class_register.dart";
import 'page_data.dart';
// This code was generated on 2021-09-03 12:13
// class
class Registry {
  // fields
  final String appName;
  final List<ClassRegister> registeredClasses;
  // fields end
  Registry({required this.appName, required this.registeredClasses});
  factory Registry.fromJson(Map<String, dynamic> data) {
    var registeredClassesList = data['registeredClasses'];
    List<ClassRegister> listOfRegisteredClasses = [];
    for(var i = 0; i < registeredClassesList.length; i++){
      listOfRegisteredClasses.add(ClassRegister.fromJson(registeredClassesList[i]));
    }
    return Registry(
      appName: data['appName'],
      registeredClasses: listOfRegisteredClasses,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'registeredClasses': registeredClasses.map((e) => e.toMap()).toList(),
    };
  }
}
