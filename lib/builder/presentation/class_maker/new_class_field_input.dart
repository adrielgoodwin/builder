import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
// Providers
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';
// Models
import '../../models/field_data.dart';
// Widgets
import '../../someWidgets.dart';
// Colors
import '../../colors/colors.dart';

/// THINGS TO DO HERE:
/// Make class selector type selectable, cuz dropdowns suck
/// factor out state from functions where its not used anymore

class NewClassFieldInput extends StatefulWidget {
  const NewClassFieldInput(
      {Key? key, required this.fieldId, required this.removeWidget})
      : super(key: key);

  final Function removeWidget;
  final String fieldId;
  // final FocusNode focusNode;

  @override
  _NewClassFieldInputState createState() => _NewClassFieldInputState();
}

class _NewClassFieldInputState extends State<NewClassFieldInput> {
  var uuid = const Uuid();

  late FieldData fieldData;
  late String whichClass = "";

  @override
  void initState() {
    super.initState();
    fieldData = FieldData(id: widget.fieldId);
  }

  void _save(ClassMakerProvider prov) {
    prov.updateField(fieldData);
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);
    return Container(
      height: 50,
      // width: double.infinity,
      // alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 85,
            child: typeSelector(state),
          ),
          // Is a list checkbox
          SizedBox(
            width: 85,
            child: CheckListItem(
              'IsAList',
              (checked) => setState(
                () {
                  fieldData.isAList = checked;
                },
              ),
            ),
          ),
          Flexible(
            child: TextField(
              onChanged: (fieldName) {
                setState(() {
                  fieldData.name = fieldName;
                });
                _save(state);
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: C.darkGray),
                  borderRadius: BorderRadius.circular(11.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: C.darkGray),
                  borderRadius: BorderRadius.circular(15.5),
                ),
                hoverColor: Colors.white70,
                hintText: "field name",
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.remove,
          //     color: Colors.red,
          //   ),
          //   onPressed: () => widget.removeWidget(widget.fieldId),
          // ),
        ],
      ),
    );
  }

  /// Type Selector

  Widget typeSelector(ClassMakerProvider state) {
    return DropdownButton<String>(
      value: fieldData.type,
      // icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          fieldData.type = newValue!;
          if (newValue == 'Class') fieldData.isAClass = true;
        });
        _save(state);
      },
      items: <String>['String', 'int', 'double', 'DateTime', 'Class']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  /// Class select

// Widget classSelector(ClassMakerProvider state,
//     List<String> classesAsStrings) {
//   if (classesAsStrings.isEmpty) classesAsStrings = ['Choose A Class!'];
//   return DropdownButton<String>(
//     value: whichClass,
//     // icon: const Icon(Icons.arrow_downward),
//     iconSize: 24,
//     elevation: 16,
//     style: const TextStyle(color: Colors.deepPurple),
//     underline: Container(
//       height: 2,
//       color: Colors.deepPurpleAccent,
//     ),
//     onChanged: (String? newValue) {
//       setState(() {
//         whichClass = newValue!;
//       });
//       _save(state);
//     },
//     items: ['Choose A Class!', ...classesAsStrings].map<
//         DropdownMenuItem<String>>((String value) {
//       print("classes as strings: $value");
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList(),
//   );
// }
}
