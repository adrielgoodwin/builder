import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';
import '../../models/field_data.dart';
import 'package:uuid/uuid.dart';

/// THINGS TO DO HERE:
/// Make class selector type selectable, cuz dropdowns suck
/// factor out state from functions where its not used anymore

class NewClassFieldInput extends StatefulWidget {
  const NewClassFieldInput({Key? key, required this.parentClassId, required this.widgetId, required this.removeWidget, required this.fieldData}) : super(key: key);

  final String parentClassId;
  final FieldData? fieldData;
  final Function removeWidget;
  final String widgetId;

  @override
  _NewClassFieldInputState createState() => _NewClassFieldInputState();
}

class _NewClassFieldInputState extends State<NewClassFieldInput> {

  String fieldName = "";
  String fieldType = "String";
  bool isAClass = false;
  String whichClass = "";
  bool isAList = false;
  String listOrSingle = "Singular";

  var uuid = const Uuid();

  var fieldNameController = TextEditingController();

  late String id;

  bool hasInit = false;

  void _save(ClassMakerProvider prov) {
    prov.updateField(FieldData(parentClass: widget.parentClassId, id: id, type: isAClass ? whichClass : fieldType, name: fieldName, description: 'description', isAClass: isAClass, isAList: isAList));
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);

    List<String> classesAsStrings = state.existingClasses.isNotEmpty ? state.existingClasses.map((e) => e.name).toList() : ['No classes yet'];

    if (!hasInit) {
      whichClass = classesAsStrings[0];
      if(fieldName.isNotEmpty) {
        setState(() {
        fieldNameController.text = fieldName;
      });
      }
      hasInit = true;
    }

    return Container(
      height: 78,
      width: double.infinity,
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () => widget.removeWidget(widget.widgetId, id),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: typeSelector(state),
                  fit: FlexFit.loose,
                ),
                Flexible(
                  child: isAClass
                      ? classSelector(state, classesAsStrings)
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  fit: FlexFit.loose,
                ),
              ],
            ),
          ),
          Flexible(
            child: listOrSingleSelector(state),
          ),
          Flexible(
            child: TextField(
              controller: fieldNameController,
              onChanged: (value) {
                setState(() {
                  fieldName = value;
                });
                _save(state);
              },
              decoration: InputDecoration(
                label: const Text("field name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Type Selector

  Widget typeSelector(ClassMakerProvider state) {
    return DropdownButton<String>(
      value: fieldType,
      // icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          fieldType = newValue!;
          if (newValue == 'Class') {
            isAClass = true;
          } else {
            isAClass = false;
          }
        });
        _save(state);
      },
      items: <String>['String', 'int', 'double', 'DateTime', 'Class'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  /// Class select

  Widget classSelector(ClassMakerProvider state, List<String> classesAsStrings) {
    if(classesAsStrings.isEmpty) classesAsStrings = ['Choose A Class!'];
    return DropdownButton<String>(
      value: whichClass,
      // icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          whichClass = newValue!;
        });
        _save(state);
      },
      items: ['Choose A Class!', ...classesAsStrings].map<DropdownMenuItem<String>>((String value) {
        print("classes as strings: $value");
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  /// List or single select

  Widget listOrSingleSelector(ClassMakerProvider state) {
    return DropdownButton<String>(
      value: listOrSingle,
      // icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (newValue) {
        setState(() {
          if (newValue == 'List') {
            isAList = true;
            listOrSingle = 'List';
          } else if (newValue == 'Singular') {
            isAList = false;
            listOrSingle = 'Singular';
          }
        });
        _save(state);
      },
      items: <String>['Singular', 'List'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
