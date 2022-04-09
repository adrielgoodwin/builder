import 'package:flutter/material.dart';
///
/// Form input types:
/// Text, Longtext, number, date, class,
/// List<Text>, List<Class>
///
/// I will use these functions as the mock up in the form builder
///


/// Text input
String unwiredTextInput(String fieldName) {
  return '''TextFormField(
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(40),
      filled: true,
      fillColor: Colors.blue.shade100,
      border: OutlineInputBorder(),
      labelText: 'label',
      hintText: 'hint',
      helperText: 'help',
      counterText: 'counter',
      icon: Icon(Icons.star),
      prefixIcon: Icon(Icons.favorite),
      suffixIcon: Icon(Icons.park),
    ),
    onSaved: (value) {
      setState(() {
        _fieldName = value;
      });
    },
    // The validator receives the text that the user has entered.
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
  )''';
}

/// Number input
Widget unwiredNumberInput(String fieldName) {
  return TextFormField(
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(40),
      filled: true,
      fillColor: Colors.blue.shade100,
      border: OutlineInputBorder(),
      labelText: fieldName,
      hintText: 'hint',
      helperText: 'help',
      counterText: 'counter',
      icon: Icon(Icons.star),
      prefixIcon: Icon(Icons.favorite),
      suffixIcon: Icon(Icons.park),
    ),

    // The validator receives the text that the user has entered.
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a number';
      }
      return null;
    },
  );
}
