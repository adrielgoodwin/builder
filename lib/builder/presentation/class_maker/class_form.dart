import 'dart:async';

import 'package:builder/builder/state/class_maker_provider.dart';
import 'package:flutter/material.dart';
import 'class_field_input.dart';
import '../../models/class_data.dart';
import '../../models/field_data.dart';
import 'package:provider/provider.dart';
import '../../colors/colors.dart';
import 'package:uuid/uuid.dart';

class ClassForm extends StatefulWidget {
  const ClassForm({Key? key, required this.classData}) : super(key: key);

  final ClassData classData;

  @override
  _ClassFormState createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  var uuid = const Uuid();

  Map<String, Widget> fieldWidgets = {};

  late ClassData classData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classData = widget.classData;
    if(classData.fieldData.isNotEmpty) {
      /// dont think this is neccesarry but maybe
      var fieldDatas = classData.fieldData;
      fieldDatas.removeWhere((element) => element.name == 'id');
      for(var fieldData in fieldDatas) {
        _addExistingFieldWidget(fieldData);
      }
    } else {
      _addNewFieldWidget();
    }
    /// Set fields
  }

  bool fieldExists(String fieldName, String id) {
    for(var y in classData.fieldData) {
      if(y.name == fieldName && y.id != id){
        return true;
      }
    }
    return false;
  }

  void removeWidget(String widgetId, String fieldId) {
    setState(() {
      fieldWidgets.removeWhere((key, value) => key == widgetId);
      classData.fieldData.removeWhere((field) => field.id == fieldId);
    });
  }

  void _addExistingFieldWidget(FieldData fieldData) {
    var widgetId = uuid.v1();
    setState(() {
      fieldWidgets[widgetId] = ClassFieldInput(parentClass: classData.name, fieldExists: fieldExists, widgetId: widgetId, removeWidget: removeWidget, updateFieldData: _updateFieldData, fieldData: fieldData);
    });
  }

  void _addNewFieldWidget() {
    var id = uuid.v1();
    var widgetId = uuid.v1();
    setState(() {
      var fieldData = FieldData(parentClass: classData.name, type: 'String', id: id, name: 'name', description: 'description', isAClass: false, isAList: false);
      fieldWidgets[widgetId] = ClassFieldInput(
        fieldExists: fieldExists,
        parentClass: classData.name,
        widgetId: widgetId,
        fieldData: fieldData,
        removeWidget: removeWidget,
        updateFieldData: _updateFieldData,
      );
      classData.fieldData.add(fieldData);
    });
  }

  void _updateFieldData(FieldData fieldData) {
    var index = classData.fieldData.indexWhere((element) => element.id == fieldData.id);
    classData.fieldData[index] = fieldData;
  }

  String formatClassName(String value) {
    List<int> spaces = indexesOfAll(value, " ");
    String formattedClassName = "";
    for (var i = 0; i < spaces.length; i++) {
      String segment;
      // check to see if we are at beginning
      if (i == 0) {
        segment = [value.substring(0, spaces[0]), value.substring(spaces[0], spaces[0] + 1).toUpperCase()].join("");
      } else {
        segment = [value.substring(spaces[i - 1], spaces[i]), value.substring(spaces[i], spaces[i] + 1).toUpperCase()].join("");
      }
      formattedClassName += segment;
    }
    return formattedClassName;
  }

  List<int> indexesOfAll(String string, String thing) {
    List<int> indexes = [];
    var moreThings = true;
    var index = 0;
    var newIndex = 0;
    while (moreThings) {
      newIndex = string.indexOf(thing);
      if (newIndex != -1) {
        indexes = [...indexes, newIndex + index];
        newIndex = string.substring(index + 1).indexOf(" ");
      } else {
        moreThings = false;
      }
    }
    return indexes;
  }

  @override
  Widget build(BuildContext context) {
    var saveAndWriteFiles = Provider.of<ClassMakerProvider>(context, listen: false).saveAndWriteFiles;
    var deleteClass = Provider.of<ClassMakerProvider>(context, listen: false).deleteClass;
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          classNameSetter(saveAndWriteFiles, deleteClass),
          newFields(),
          newFieldButton(),
        ],
      ),
    );
  }

  /// Class name setter

  Widget classNameSetter(Function saveAndWriteFile, Function deleteClass) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        classData.name = value;
                      });
                    },
                    decoration: InputDecoration(
                      label: const Text("Class"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 33,
                ),
                Flexible(
                  flex: 4,
                  child: Text(
                    classData.name,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  if(classData.name.length >= 2 && classData.fieldData.length >= 2) {
                    saveAndWriteFile(classData);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Flexible(flex: 5, child: Text("Save Class")),
                    Flexible(
                        child: Icon(
                      Icons.done,
                      color: Colors.green,
                    )),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () => deleteClass(classData),
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ))
        ],
      ),
    );
  }

  Widget newFields() {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: fieldWidgets.values.toList(),
      ),
    );
  }

  /// New field button

  Widget newFieldButton() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(38.0),
        child: IconButton(
          onPressed: _addNewFieldWidget,
          hoverColor: Colors.white30,
          icon: Icon(
            Icons.add,
            color: C.gold,
            size: 33,
          ),
        ),
      ),
    );
  }
}
