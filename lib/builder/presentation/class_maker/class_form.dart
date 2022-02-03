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
  }

  void removeWidget(String id) {
    fieldWidgets.removeWhere((key, value) => key == id);
    classData.fieldData.removeWhere((element) => element.id == id);
  }

  void _addNewFieldWidget() {
    var id = uuid.v1();
    setState(() {
      var fieldData = FieldData(parentClass: classData.name, type: 'String', id: id, name: 'newField', description: 'description', isAClass: false, isAList: false);
      fieldWidgets[id] = ClassFieldInput(
        parentClass: classData.name,
        id: id,
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
    var state = Provider.of<ClassMakerProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          classNameSetter(state),
          newFields(),
          newFieldButton(),
        ],
      ),
    );
  }

  /// Class name setter

  Widget classNameSetter(ClassMakerProvider state) {
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
                onPressed: () => state.writeFiles(),
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
              onPressed: () => state.deleteClass(classData),
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
