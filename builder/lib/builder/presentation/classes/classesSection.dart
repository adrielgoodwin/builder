import 'package:flutter/material.dart';
// Providers
import 'package:provider/provider.dart';
import '../../state/state.dart';
// Colors
import '../../colors/colors.dart';
import '../../models/class_data.dart';
import '../../models/field_data.dart';

class ClassSection extends StatelessWidget {
  const ClassSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AllState>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          child: Column(
        // Map out each class
        children: state.classes.map((e) => ClassDisplay(e)).toList(),
      )),
    );
  }
}

class ClassDisplay extends StatelessWidget {
  const ClassDisplay(this.theClass, {Key? key}) : super(key: key);

  final ClassData theClass;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AllState>(context);
    var selected = state.selectedClass.id == theClass.id;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selected ? Column(children: [SizedBox(height: 12),Icon(Icons.circle, color: Colors.green, size: 10)],) : SizedBox(width: 10),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  theClass.name,
                  style: TextStyle(
                      fontSize: 22, color: C.orange, fontWeight: FontWeight.w500),
                ),
          
                /// Map out field of class
                ...theClass.fieldData.map((e) => FieldDisplay(e)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FieldDisplay extends StatelessWidget {
  const FieldDisplay(this.field, {Key? key}) : super(key: key);

  final FieldData field;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AllState>(context);
    var selectedField = state.selectedField;
    String type = "";
    field.isAList ? type = "List<${field.type}>" : type = field.type;
    var showSelected = selectedField.id == field.id && state.activePlugEnum == ActionPlugs.classChanger;
    return Row(
      children: [
        // Check if the field is selected
        showSelected
            ? const Icon(
                // If it is, put a little green dot beside it
                Icons.circle,
                color: Colors.green,
                size: 10,
              )
            : const SizedBox(
                // Otherwise, a sized box so it doesnt move position on screen when selected/unselected
                width: 10,
              ),
        Text(
          // Show type eg. ~ double age
          "  $type",
          style: TextStyle(
              fontSize: 18, color: C.teal, fontWeight: FontWeight.w400),
        ),
        Text(
          //
          "  ${field.name}",
          style: TextStyle(
              fontSize: 18, color: C.purple, fontWeight: FontWeight.w400),
        ),
        Text(
          //
          '  "${field.description}"',
          style: TextStyle(
              fontSize: 18, color: C.gold, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
