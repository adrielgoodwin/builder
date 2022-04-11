import '../../models/class_data.dart';
import '../../extensions.dart';

String composeProvider(List<ClassData> classDatas) {

  var c = classDatas;

  List<String> components = [];

  var imports = c.map((e) => "import '../data-classes/${e.name}.dart';").toList().join('\n');

  /// Imports
  components.add("""import 'package:flutter/cupertino.dart';
$imports \n
""");

  /// Provider name or whatevs
  components.add("class MainProvider with ChangeNotifier {\n");

  var cruds = c.map((e) => makeCrud(e)).toList().join();

  /// CRUD
  components.add(cruds);

  components.add("}");

  return components.join();
}

String makeCrud(ClassData c) {
  var Cn = c.name;
  var Cns = Cn + "s";
  var cn = c.name.paramify();
  var cns = cn + "s";
  return """
  ///_____________________________
  /// $Cn 
  
  Map<String, $Cn> _$cns = {};

  List<$Cn> get get$Cns => _$cns.values.toList();

  $Cn get$Cn(String name) => _$cns[name]!;

  List<$Cn> get${Cns}ByName(String string) {
    return _$cns.values.where(($cn) => $cn.name.substring(0, string.length) == string).toList();
  }
  
  List<$Cn> get${Cns}ListByNameList(List<String> names) {
    return get$Cns.where((element) => names.contains(element.name)).toList();
  }

  void add$Cn($Cn $cn) {
    _$cns.addAll({$cn.name: $cn});
    notifyListeners();
  }

  void remove$Cns($Cn $cn) {
    _$cns.remove($cn.name);
    notifyListeners();
  }  
 """;
}
