import 'package:flutter/material.dart';
// Providers
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';
// Models
import '../../models/class_data.dart';
import '../../models/field_data.dart';
// Colors
import '../../colors/colors.dart';

class NewClassDisplay extends StatelessWidget {
  const NewClassDisplay({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var cmp = Provider.of<ClassMakerProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cmp.newClass.name,
            style: TextStyle(fontSize: 22, color: C.orange, fontWeight: FontWeight.w500),
          ),
          ...cmp.newClass.fieldData.map((e) {
            String type = "";
            e.isAList ? type = "List<${e.type}>" : type = e.type ;
            return Row(
              children: [
                cmp.newClass.fieldData[cmp.selectedIndex].id == e.id ? const Icon(Icons.circle, color: Colors.green, size: 10,) : const SizedBox(width: 10,),
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
