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



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          classNameSetter(classData: classData),
          newFields(),
          newFieldButton(),
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

class classNameSetter extends StatefulWidget {
  const classNameSetter({Key? key, required this.classData}) : super(key: key);

  final ClassData classData;

  @override
  State<classNameSetter> createState() => _classNameSetterState();
}

class _classNameSetterState extends State<classNameSetter> {
  
  var classNameController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classNameController.text = widget.classData.name;
  }
  
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);
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
                    controller: classNameController,
                    onChanged: (value) {
                      setState(() {
                        widget.classData.name = [value.substring(0, 1).toUpperCase(), value.substring(1)].join();
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
                    widget.classData.name,
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
                  if(widget.classData.name.length >= 2 && widget.classData.fieldData.length >= 2) {
                    state.saveAndWriteFiles(widget.classData);
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
              onPressed: () => state.deleteClass(widget.classData),
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ))
        ],
      ),
    );
  }
}

