import '../../models/class_data.dart';

/// Takes ClassData as an input
/// Sets up the form to submit a new instance of the class to the database
/// Loops over fields and generates appropriate fields for the types

String composeForm(ClassData classData) {

  String imports = '''import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../data-classes/${classData.name}.dart';
''';

  String formHead = '''
class ${classData.name}Form extends StatefulWidget {
  const ${classData.name}Form({Key? key, required this.submitCallback}) : super(key: key);
  
  final Function submitCallback;
  
  @override
  State<${classData.name}Form> createState() => _${classData.name}FormState();
}

class _${classData.name}FormState extends State<${classData.name}Form> {

  final _formKey = GlobalKey<FormState>();

''';

  String variables = "";
  for (var y in classData.fieldData) {
    /// set variables
    variables += "  late ${y.type} ${y.name}; \n";
    /// also add imports for fields that have other classes as types
    if(y.isAClass) imports += "import '../data-classes/${y.type}.dart';";
  }

  String formTop = '''
  @override
  Widget build(BuildContext context) {
    
    var p = Provider.of<MainProvider>(context);
    
    return Form(
      key: _formKey,
      child: Column(
        children: [  
''';

  String inputs = "";
  for (var y in classData.fieldData) {
    if(y.type == 'int') {
      inputs += intInput(y.name);
    } else if (y.type == 'double') {
      inputs += doubleInput(y.name);
    } else if(y.type == 'class' && !y.isAList) {
      inputs += singleSearch(y.name, y.type);
    } else if(y.type == 'class' && y.isAList) {
      inputs += multiSearch(y.name, y.type);
    } else {
      inputs += textInput(y.name);
    }
  }


  String classInstantiationFields = "";
  for(var y in classData.fieldData) {
    classInstantiationFields += "${y.name}: ${y.name},\n                ";
  }

  String submitButton = '''
  ElevatedButton(
    child: Text("Submit"),
    onPressed: () {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();    
        p.add${classData.name}(${classData.name}(
        $classInstantiationFields
        ));
        widget.submitCallback();
      }
    },
  ),                
''';

  var end = """
          ],));
  }
}  
""";

  return [imports, formHead, variables, formTop, inputs, submitButton, end].join();

}

String singleSearch(String fieldName, String className) {
  return """    SingleSearch(dataSet: p.get$className, resultCallback: (value) {
      setState(() {
        $fieldName = value;
      });
    }),
""";
}

String multiSearch(String fieldName, String className) {
  return """    MultiSearch(dataSet: p.get$className, resultCallback: (value) {
      setState(() {
        $fieldName = value;
      });
    }),
""";
}


String intInput(String fieldName) {
  return '''
    TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (value) {
        setState(() {
          $fieldName = int.parse(value!);
        });
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(40),
        filled: true,
        fillColor: Colors.blue.shade100,
        border: OutlineInputBorder(),
        labelText: '$fieldName',
        hintText: 'hint',
        helperText: 'help',
        counterText: 'counter',
        icon: Icon(Icons.star),
        prefixIcon: Icon(Icons.favorite),
        suffixIcon: Icon(Icons.park),
      ),
    ),
  ''';
}

String doubleInput(String fieldName) {
  return '''
    TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (value) {
        setState(() {
          $fieldName = double.parse(value!);
        });
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(40),
        filled: true,
        fillColor: Colors.blue.shade100,
        border: OutlineInputBorder(),
        labelText: '$fieldName',
        hintText: 'hint',
        helperText: 'help',
        counterText: 'counter',
        icon: Icon(Icons.star),
        prefixIcon: Icon(Icons.favorite),
        suffixIcon: Icon(Icons.park),
      ),
    ),
  ''';
}

String textInput(String fieldName) {
  return '''TextFormField(
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(40),
      filled: true,
      fillColor: Colors.blue.shade100,
      border: OutlineInputBorder(),
      labelText: '$fieldName}',
      hintText: 'hint',
      helperText: 'help',
      counterText: 'counter',
      icon: Icon(Icons.star),
      prefixIcon: Icon(Icons.favorite),
      suffixIcon: Icon(Icons.park),
    ),
    onSaved: (value) {
      setState(() {
        $fieldName = value!;
      });
    },
    // The validator receives the text that the user has entered.
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
  ),
''';
}