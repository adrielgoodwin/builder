import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';
import '../../models/field_data.dart';
import 'package:uuid/uuid.dart';

class ClassFieldInput extends StatefulWidget {
  const ClassFieldInput({Key? key, required this.parentClass, required this.id, required this.removeWidget, required this.updateFieldData, required this.fieldData}) : super(key: key);

  final String parentClass;
  final FieldData? fieldData;
  final Function removeWidget;
  final Function updateFieldData;
  final String id;

  @override
  _ClassFieldInputState createState() => _ClassFieldInputState();
}

class _ClassFieldInputState extends State<ClassFieldInput> {
  String fieldName = "";
  String fieldType = "String";
  bool isAClass = false;
  String whichClass = "";
  bool isAList = false;
  String listOrSingle = "Singular";

  var uuid = Uuid();

  late String id;

  bool hasInit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.fieldData != null) {
      var x = widget.fieldData!;
      id = x.id;
      fieldName = x.name;
      fieldType = x.type;
      isAClass = x.isAClass;
      isAList = x.isAClass;
    } else {
      id = uuid.v4();
    }
  }

  void _save(ClassMakerProvider state) {
    var fieldData = FieldData(parentClass: widget.parentClass, id: id, type: isAClass ? whichClass : fieldType, name: fieldName, description: 'description', isAClass: isAClass, isAList: isAList);
    widget.updateFieldData(fieldData);
  }

  void _remove(ClassMakerProvider state) {
    setState(() {
      widget.removeWidget(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);

    List<String> classesAsStrings = state.newAppClasses.isNotEmpty ? state.newAppClasses.map((e) => e.name).toList() : ['No classes yet'];

    if (!hasInit) {
      whichClass = classesAsStrings[0];
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
            onPressed: () => _remove(state),
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

  /// Type Select

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
      items: classesAsStrings.map<DropdownMenuItem<String>>((String value) {
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
      onChanged: (String? newValue) {
        setState(() {
          listOrSingle = newValue!;
          if (newValue == 'List') {
            isAList = true;
          } else if (newValue == 'Singular') {
            isAList = false;
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
