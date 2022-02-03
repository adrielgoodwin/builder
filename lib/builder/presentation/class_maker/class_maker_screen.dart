import 'dart:async';

import 'package:builder/builder/presentation/class_maker/class_form.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Classes
import '../../models/class_data.dart';
import '../../models/field_data.dart';

/// Widgets
import 'class_field_input.dart';
import 'result_display.dart';
import 'class_form.dart';

/// Providers
import 'package:builder/builder/state/class_maker_provider.dart';
import 'package:provider/provider.dart';

/// Ui Stuff
import '../../colors/colors.dart';

class ClassMakerScreen extends StatefulWidget {
  const ClassMakerScreen({Key? key}) : super(key: key);

  @override
  _ClassMakerScreenState createState() => _ClassMakerScreenState();
}

class _ClassMakerScreenState extends State<ClassMakerScreen> {

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: C.lightGray,
                child: SingleChildScrollView(
                  child: buildSidebar(state),
                ),
              ),
            ),
            Flexible(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._buildClassForms(state),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: ResultDisplay(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildClassForms(ClassMakerProvider state) {
  if(state.isForBuilder) {
    return state.builderClasses.map((e) => ClassForm(classData: e)).toList();
  } else {
    return state.newAppClasses.map((e) => ClassForm(classData: e)).toList();
  }
}

Widget buildSidebar(ClassMakerProvider state) {
  var uuid = Uuid();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ElevatedButton(onPressed: () => state.loadRegistries(), child: Text("load classes")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Classes",
            style: TextStyle(fontSize: 26),
          ),
          IconButton(
              onPressed: () {
                state.addNewClass(ClassData(id: uuid.v4(), name: '', fieldData: [], neededImports: []));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.green,
              ))
        ],
      ),
      const SizedBox(
        height: 22,
      ),
      ..._buildClasses(state),
    ],
  );
}

List<Widget> _buildClasses(ClassMakerProvider state) {
  if(state.isForBuilder) {
    return state.builderClasses.map((classData) => sidebarClassItem(classData, state)).toList();
  } else {
    return state.newAppClasses.map((classData) => sidebarClassItem(classData, state)).toList();
  }
}

Widget sidebarClassItem(ClassData classData, ClassMakerProvider state) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {},
          child: Text(
            classData.name,
            style: TextStyle(fontSize: 16, color: C.orange, fontWeight: FontWeight.w500),
          ),
        ),
        ...classData.fieldData.map((e) {
          return Row(
            children: [
              Text(
                "  ${e.type}",
                style: TextStyle(color: C.teal, fontWeight: FontWeight.w400),
              ),
              Text(
                "  ${e.name}",
                style: TextStyle(color: C.purple, fontWeight: FontWeight.w400),
              ),
            ],
          );
        }).toList(),
      ],
    ),
  );
}
