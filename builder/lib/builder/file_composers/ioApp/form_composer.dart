import '../../models/class_data.dart';
import '../../extensions.dart';
/// Takes ClassData as an input
/// Sets up the form to submit a new instance of the class to the database
/// Loops over fields and generates appropriate fields for the types

String composeForm(ClassData classData) {

  String imports = '''import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../data-classes/${classData.name}.dart';

''';

  var littleSpace = "  SizedBox(height: 10,),\n";

  /// Check for search box requirements
  for(var y in classData.fieldData) {
    if(y.isAClass) imports += "import '../io_app/widgets/singleSearch.dart';\n";
    if(y.isAClass && y.isAList) imports += "import '../io_app/widgets/multiSearch.dart';\n";
  }

  String formHead = '''
class ${classData.name}Form extends StatefulWidget {
  const ${classData.name}Form({Key? key}) : super(key: key);
  
  @override
  State<${classData.name}Form> createState() => _${classData.name}FormState();
}

class _${classData.name}FormState extends State<${classData.name}Form> {

  final _formKey = GlobalKey<FormState>();

''';

  /// Provider access for searchable datasets
  String dataSets = "";

  String variables = "";
  for (var y in classData.fieldData) {
    /// set variables
    if(y.isAList) {
      variables += "  late List<${y.type}> ${y.name.paramify()}; \n";
    } else {
      variables += "  late ${y.type} ${y.name.paramify()}; \n";
    }
    /// also add imports for fields that have other classes as types
    if(y.isAClass) imports += "import '../data-classes/${y.type}.dart';";
    if(y.isAClass) dataSets += "var existing${y.type}s = p.get${y.type}s.map((e) => e.name).toList();\n";
  }

  String formTop = '''
  @override
  Widget build(BuildContext context) {
    
    var p = Provider.of<MainProvider>(context);
    $dataSets
   
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
''';

  String inputs = "";
  for (var y in classData.fieldData) {
    if(y.type == 'int') {
      inputs += intInput(y.name);
    } else if (y.type == 'double') {
      inputs += doubleInput(y.name);
    } else if(y.isAClass && !y.isAList) {
      inputs += singleSearch(y.name, y.type);
    } else if(y.isAClass && y.isAList) {
      inputs += multiSearch(y.name, y.type);
    } else {
      inputs += textInput(y.name);
    }
  }


  String classInstantiationFields = "";
  for(var y in classData.fieldData) {
    classInstantiationFields += "${y.name.paramify()}: ${y.name.paramify()},\n                ";
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
      }
      _formKey.currentState!.reset();
    },
  ),                
''';

  var end = """
          ],))));
  }
}  
""";

  return [imports, formHead, variables, formTop, inputs, littleSpace, submitButton, end].join();

}

String singleSearch(String fieldName, String className) {
  return """    SingleSearch(dataSet: existing${className}s, label: 'Choose a $fieldName', resultCallback: (value) {
      setState(() {
        $fieldName = p.get${className.classify()}(value);
      });
    }),
""";
}
/// TODO handle support for multiple
String multiSearch(String fieldName, String className) {
  return """    MultiSearch(dataSet: existing${className}s, label: 'Choose a few ${fieldName}s', resultCallback: (value) {
      setState(() {
        ${fieldName.paramify()} = p.get${className}sListByNameList(value);
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
      decoration: const InputDecoration(
        labelText: '$fieldName',
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
      decoration: const InputDecoration(
        labelText: '$fieldName',
      ),
    ),
  ''';
}

String textInput(String fieldName) {
  return '''TextFormField(
    keyboardType: TextInputType.text,
    decoration: const InputDecoration(
      labelText: '$fieldName',
    ),
    onSaved: (value) {
      setState(() {
        ${fieldName.paramify()} = value!;
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