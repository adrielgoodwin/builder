import 'package:flutter/material.dart';
// Providers
import 'state/class_maker_provider.dart';
import 'package:builder/builder/state/class_maker_provider.dart';
// Models
import 'models/field_data.dart';
// Colors
import 'colors/colors.dart';

class ClassFieldsEditor extends StatefulWidget {
  const ClassFieldsEditor(this.cmp, {Key? key}) : super(key: key);

  final ClassMakerProvider cmp;

  @override
  State<ClassFieldsEditor> createState() => _ClassFieldsEditorState();
}

class _ClassFieldsEditorState extends State<ClassFieldsEditor> {

  var selectedIndex = 0;

  bool isSelected(String id) => widget.cmp.newClass.fieldData.indexWhere((field) => field.id == id) == selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:,
    );
  }


  Widget fieldDisplay(FieldData e) {
    String type = "";
    e.isAList ? type = "List<${e.type}>" : type = e.type;
    return Row(
      children: [
        isSelected(e.id) ? const Icon(Icons.keyboard_arrow_right, size: 20,) : const SizedBox(width: 20),
        Text(
          "  $type",
          style: TextStyle(
              fontSize: 18, color: C.teal, fontWeight: FontWeight.w400),
        ),
        Text(
          "  ${e.name}",
          style: TextStyle(
              fontSize: 18, color: C.purple, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}