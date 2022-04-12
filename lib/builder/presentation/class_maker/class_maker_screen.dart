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
    var loadRegistriesFunc = Provider.of<ClassMakerProvider>(context, listen: false).loadRegistries;
    var addClassFunc = Provider.of<ClassMakerProvider>(context, listen: false).addNewClass;
    var newAppClasses = Provider.of<ClassMakerProvider>(context).newAppClasses;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: C.lightGray,
                child: SingleChildScrollView(
                  child: buildSidebar(newAppClasses, loadRegistriesFunc, addClassFunc),
                ),
              ),
            ),
            Flexible(
              flex: 9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._buildClassForms(newAppClasses),
                        ],
                      ),
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

List<Widget> _buildClassForms(List<ClassData> newAppClasses) {
  // if(state.isForBuilder) {
  //   return state.builderClasses.map((e) => ClassForm(classData: e)).toList();
  // } else {
  return newAppClasses.map((e) => ClassForm(classData: e)).toList();
  // }
}

Widget buildSidebar(List<ClassData> newAppClasses, Function loadRegistries, Function addNewClass) {
  var uuid = const Uuid();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ElevatedButton(onPressed: () => loadRegistries(), child: const Text("load classes")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Classes",
            style: TextStyle(fontSize: 26),
          ),
          IconButton(
              onPressed: () {
                addNewClass(ClassData(id: uuid.v4(), name: '', fieldData: [], neededImports: []));
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
      ..._buildSidebarClassView(newAppClasses),
    ],
  );
}

List<Widget> _buildSidebarClassView(List<ClassData> newAppClasses) {
  // if(state.isForBuilder) {
  //   return state.builderClasses.map((classData) => sidebarClassItem(classData, state)).toList();
  // } else {
  return newAppClasses.map((classData) => sidebarClassItem(classData)).toList();
  // }
}

Widget sidebarClassItem(ClassData classData) {
  var fieldDatas = classData.fieldData;
  fieldDatas.removeWhere((element) => element.name == 'id');
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
            style: TextStyle(fontSize: 22, color: C.orange, fontWeight: FontWeight.w500),
          ),
        ),
        ...fieldDatas.map((e) {
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
