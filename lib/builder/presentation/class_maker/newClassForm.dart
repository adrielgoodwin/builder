import 'package:builder/builder/state/class_maker_provider.dart';
import 'package:flutter/material.dart';
import 'new_class_field_input.dart';
import '../../models/field_data.dart';
import 'package:provider/provider.dart';
import '../../colors/colors.dart';
import 'package:uuid/uuid.dart';


class NewClassForm extends StatefulWidget {
  const NewClassForm({Key? key}) : super(key: key);

  @override
  _NewClassFormState createState() => _NewClassFormState();
}

class _NewClassFormState extends State<NewClassForm> {
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    var cmp = Provider.of<ClassMakerProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Class Name
          TextField(
            decoration: const InputDecoration(
              hintText: "A good name",
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 8),
            ),
            onChanged: (newName) => cmp.updateClassName(newName),
          ),
          const SizedBox(height: 10,),
          // Field Inputs
          ...cmp.fieldWidgets,
          // New Field
          SizedBox(
            width: 30,
            child: IconButton(
              onPressed: () => cmp.addField(),
              hoverColor: Colors.white30,
              icon: Icon(
                Icons.add,
                color: C.gold,
                size: 33,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

