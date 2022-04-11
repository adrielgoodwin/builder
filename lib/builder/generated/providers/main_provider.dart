import 'package:flutter/cupertino.dart';
import '../data-classes/NO.dart'; 

class MainProvider with ChangeNotifier {
  ///_____________________________
  /// NO 
  
  Map<String, NO> _nOs = {};

  List<NO> get getNOs => _nOs.values.toList();

  NO getNO(String name) => _nOs[name]!;

  List<NO> getNOsByName(String string) {
    return _nOs.values.where((nO) => nO.name.substring(0, string.length) == string).toList();
  }
  
  List<NO> getNOsListByNameList(List<String> names) {
    return getNOs.where((element) => names.contains(element.name)).toList();
  }

  void addNO(NO nO) {
    _nOs.addAll({nO.name: nO});
    notifyListeners();
  }

  void removeNOs(NO nO) {
    _nOs.remove(nO.name);
    notifyListeners();
  }  
 }