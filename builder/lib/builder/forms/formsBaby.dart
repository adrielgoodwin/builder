import 'package:flutter/material.dart';
import '../models/class_data.dart';
import '../state/state.dart';
import 'package:provider/provider.dart';

List<Widget> makeMeAForm(ClassData classData, AllState state) {
  List<Widget> inputsBiiiitch = [];
  for (var i = 0; i < classData.fieldData.length; i++) {
    makeFormField(state, classData.fieldData[i].name, classData.name);
  }
  return inputsBiiiitch;
}

class SampleForm extends StatelessWidget {
  const SampleForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AllState>(context);
    return Column(
      children: [],
    );
  }
}

Widget makeFormField(AllState state, String fieldName, String className) {
  return TextField(
    onChanged: (value) =>
        state.setFieldDescription(value, fieldName, className),
  );
}
