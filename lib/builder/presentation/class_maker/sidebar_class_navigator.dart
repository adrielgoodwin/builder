import 'package:flutter/material.dart';
// Providers
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';
// Models
import '../../models/class_data.dart';
import '../../models/field_data.dart';
// Colors
import '../../colors/colors.dart';

class SidebarClassNavigator extends StatefulWidget {
  const SidebarClassNavigator({Key? key, required this.classData}) : super(key: key);

  final ClassData classData;

  @override
  State<SidebarClassNavigator> createState() => _SidebarClassNavigatorState();
}

class _SidebarClassNavigatorState extends State<SidebarClassNavigator> {

  late String className;
  late List<FieldData> fields;

  @override
  void initState() {
    super.initState();
    className = widget.classData.name;
    fields = widget.classData.fieldData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Text(
              className,
              style: TextStyle(fontSize: 22, color: C.orange, fontWeight: FontWeight.w500),
            ),
          ),
          ...fields.map((e) {
            String type = "";
            e.isAList ? type = "List<${e.type}>" : type = e.type ;
            return Row(
              children: [
                Text(
                  "  $type",
                  style: TextStyle(fontSize: 18, color: C.teal, fontWeight: FontWeight.w400),
                ),
                Text(
                  "  ${e.name}",
                  style: TextStyle(fontSize: 18,color: C.purple, fontWeight: FontWeight.w400),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
