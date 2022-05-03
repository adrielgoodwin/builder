import 'dart:async';

import 'package:builder/builder/state/class_maker_provider.dart';
import 'package:flutter/material.dart';
import 'new_class_field_input.dart';
import '../../models/class_data.dart';
import '../../models/field_data.dart';
import 'package:provider/provider.dart';
import '../../colors/colors.dart';
import 'package:uuid/uuid.dart';


class NewClassForm extends StatefulWidget {
  const NewClassForm({Key? key, required this.classData}) : super(key: key);

  final ClassData classData;

  @override
  _NewClassFormState createState() => _NewClassFormState();
}

class _NewClassFormState extends State<NewClassForm> {
  var uuid = const Uuid();

  Map<String, Widget> fieldWidgets = {};

  void removeWidget(String widgetId, String fieldId) {
    setState(() {
      fieldWidgets.removeWhere((key, value) => key == widgetId);
      classData.fieldData.removeWhere((field) => field.id == fieldId);
    });
  }

  void _addNewFieldWidget() {
    var id = uuid.v1();
    var widgetId = uuid.v1();
    setState(() {
      var fieldData = FieldData(parentClass: classData.name, type: 'String', id: id, name: 'name', description: 'description', isAClass: false, isAList: false);
      fieldWidgets[widgetId] = ClassFieldInput(
        parentClassId: classData.id,
        widgetId: widgetId,
        fieldData: fieldData,
        removeWidget: removeWidget,
      );
      classData.fieldData.add(fieldData);
    });
  }

  @override
  Widget build(BuildContext context) {
    var cmp = Provider.of<ClassMakerProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (newName) => cmp.updateClassName(newName),
          ),
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


