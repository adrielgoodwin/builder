
import "class_register.dart";
// This code was generated on 2021-09-03 12:13
// class
class Registry {
  // fields
  String appName;
  List<ClassRegister> registeredClasses;
  // fields end
  Registry({this.appName = 'App name', this.registeredClasses = const []});
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
