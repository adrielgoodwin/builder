import 'package:flutter/material.dart';
import 'package:builder/builder/models/field_data.dart';
import 'package:flutter/foundation.dart';
import '../ids.dart';

// models
import '../models/class_data.dart';

class ClassMakerProvider with ChangeNotifier {

  /// Class Maker Section UI

  double _newClassBox = 0;
  void setNewClassBox(double x) {
    _newClassBox = x;
    print("New class box is $x");
    notifyListeners();
  }
  double get newClassBox => _newClassBox;

  bool _isMakingNewClass = false;
  void setIsMakingNewClass(bool x) {
    _isMakingNewClass = x;
    notifyListeners();
  }

  bool get isMakingNewClass => _isMakingNewClass;

  bool _classIsGood = false;
  
  void setClassIsGood(bool x) {
    _classIsGood = x;
    notifyListeners();
  }

  /// New Class Form

  // setup

  ClassData _elClass = ClassData(name: 'NewClass', id: newId(), fieldData: [FieldData(id: newId())]);

  ClassData get elClass => _elClass;

  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void beginNewClass() {
    _elClass = ClassData(name: 'NewClass', id: uuid.v1(), fieldData: [FieldData(id: uuid.v1())]);
    notifyListeners();
  }

  void setClassName(String newName) {
    _elClass.name = newName;
    notifyListeners();
  }

  // Fields

  void addField(int index) {
    print("Trying to add field");
    elClass.fieldData.insert(index, FieldData(id: newId()));
    selectedIndex = index;
    notifyListeners();
  }

  void setField(int index, FieldData field) {
    elClass.fieldData[index] = field;
    notifyListeners();
  }

  void updateField(FieldData fieldData) {
    elClass.fieldData[elClass.fieldData.indexWhere((element) => element.id == fieldData.id)] = fieldData;
  }

  void removeField(int index) {
    elClass.fieldData.removeAt(index);
  }

}

