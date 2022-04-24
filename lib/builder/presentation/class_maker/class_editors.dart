import 'package:flutter/material.dart';

// Providers
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';

// Models
import '../../models/class_data.dart';

// Widgets
import 'class_form.dart';

class ClassEditors extends StatefulWidget {
  const ClassEditors({Key? key}) : super(key: key);

  @override
  State<ClassEditors> createState() => _ClassEditorsState();
}

class _ClassEditorsState extends State<ClassEditors> {

  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          /// Class count and add new button
          Row(
            children: [
              Text("Classes in use: ${state.existingClasses.length}"),
              const SizedBox(width: 45,),
              TextButton(onPressed: state.addBlankClass, child: const Text("Add another one")),
            ],
          ),
          /// New class creation area
          newClassesSection(state.classesInCreation),
          /// Existing class editing area
          existingClassesSection(state.existingClasses),
        ],
      ),
    );
  }

  Widget existingClassesSection(List<ClassData> existingClasses) {
    List<Widget> content;
    if(existingClasses.isNotEmpty) {
      content = existingClasses.map((e) => ClassForm(classData: e)).toList();
    } else {
      content = [const Text('Nothing here yet')];
    }
    return Column(
      children: [
        const Text('Existing Classes', style: TextStyle(fontSize: 28),),
        ...content,
      ],
    );
  }

  Widget newClassesSection(List<ClassData> existingClasses) {
    List<Widget> content;
    if(existingClasses.isNotEmpty) {
      content = existingClasses.map((e) => ClassForm(classData: e)).toList();
    } else {
      content = [const SizedBox()];
    }
    return Column(
      children: [
        existingClasses.isNotEmpty ? const Text('New Classes', style: TextStyle(fontSize: 28),) : const SizedBox(),
        ...content,
      ],
    );
  }

}
