// ignore_for_file: file_names

/// todo make this a function. lol

import '../models/field_data.dart';
import '../models/class_data.dart';
import '../extensions.dart';

// import 'ClassRegister.dart';
import 'dart:io';

// class
class DataClassComposer {
  late ClassData classData;
  List<String> imports = ["import '../../models/nameValueType.dart';\n"];
  List<String> head = [];
  List<String> fields = [];
  List<String> constructor = [];
  List<String> nameValueType = [];
  List<String> fromJsonConstructor = [];
  List<String> toMapMethod = [];
  List<String> makeWithData = [];
  List<String> makeMultipleWithData = [];
  List<String> end = [];

  String composeFromClassData(ClassData classData) {
    this.classData = classData;
    go();
    return makeFile();
  }

  String makeFile() {
    return [...imports, ...head, ...fields, ...constructor, ...fromJsonConstructor, ...toMapMethod, ...nameValueType, ...makeWithData, ...makeMultipleWithData, ...end].join('\n');
  }

  void writeToFile(String pathToFile) {
    String fileString = "";
    [...imports, ...head, ...fields, ...constructor, ...fromJsonConstructor, ...toMapMethod, ...makeWithData, ...makeMultipleWithData, ...end]
        .forEach((line) => fileString += ('$line\n'));
    File file = File("$pathToFile${classData.name}.dart");
    file.writeAsString(fileString);
  }

  void go() {
    generateImports();
    generateHead();
    generateFields();
    generateConstructorFunction();
    generateFromJsonConstructor();
    generateNameValueType();
    generateToMap();
    generateMakeWithDataMethod();
    generateMakeMultipleWithDataMethod();
    generateEnd();
  }

  void generateImports() {
    if (classData.neededImports.isNotEmpty) {
      classData.neededImports.forEach((neededImport) {
        imports.add('import "$neededImport.dart";');
      });
    }
  }

  void generateHead() {
    head.add("// This code was generated on ${DateTime.now().toString().substring(0, 16)}"); // TODO make this pretty please Aylin
    head.add("// class");
    head.add("class ${classData.name} {");
  }

  void generateFields() {
    fields.add("  // fields");
    classData.fieldData.forEach((fieldData) {
      String fieldType = fieldData.type;
      if (fieldData.isAList) fieldType = "List<${fieldData.type}>";
      fields.add("  final $fieldType ${fieldData.name.paramify()};");
    });
    fields.add("  // fields end");
  }

  void generateConstructorFunction() {
    String constructorFunc = "  ${classData.name}({";
    classData.fieldData.forEach((fieldData) {
      constructorFunc += "required this.${fieldData.name.paramify()}, ";
    });
    constructor = [constructorFunc.substring(0, constructorFunc.length - 2) + "});"];
  }

  void generateNameValueType() {
    nameValueType.add("  List<NameValueType> get fieldsAndValues => [\n");
    for(var y in classData.fieldData) {
      if(y.isAList && y.isAClass) {
        nameValueType.add("      NameValueType('${y.name}', ${y.name.paramify()}.map((e) => '\${e.name}').toList() , '${y.type}', ${y.isAList}, ${y.isAClass}), \n");
      } else if(y.isAList) {
        nameValueType.add("      NameValueType('${y.name}', ${y.name.paramify()}.map((e) => '\$e').toList() , '${y.type}', ${y.isAList}, ${y.isAClass}), \n");
      } else if(y.isAClass) {
        nameValueType.add("      NameValueType('${y.name}', ${y.name.paramify()}.name, 'String', ${y.isAList}, ${y.isAClass}), \n");
      } else {
        nameValueType.add("      NameValueType('${y.name}', ${y.name.paramify()}, '${y.type}', ${y.isAList}, ${y.isAClass}), \n");
      }
    }
    nameValueType.add("  ];");
  }

  void generateFromJsonConstructor() {
    // eg. factory Happening.fromJson(Map<String, dynamic> data) {
    String functionHead = '  factory ${classData.name}.fromJson(Map<String, dynamic> data) {';
    // instantiate list for where list unpacking happens
    List<String> functionBody = [];
    // eg. return Happening(
    List<String> functionReturn = ['    return ${classData.name}('];
    classData.fieldData.forEach((fieldData) {
      String fieldName = fieldData.name;
      String fieldType = fieldData.type;

      // Check to see if its a class
      if (fieldData.isAClass) {
        if (fieldData.isAList) {
          functionBody.add("    var ${fieldName.paramify()}List = data['$fieldName'];");
          functionBody.add("    List<$fieldType> listOf${fieldType.classify()} = [];");
          functionBody.add("    for(var i = 0; i < ${fieldName.paramify()}List.length; i++){");
          functionBody.add("      listOf${fieldType.classify()}.add($fieldType.fromJson(${fieldName.paramify()}List[i]));");
          functionBody.add("    }");
          // then reference this newly made list in the return
          // eg. supplies: listOfSupplies,
          functionReturn.add("      ${fieldName.paramify()}: listOf${fieldType.classify()},");
        } else {
          // if its a class, but not a list no addition to function body, only to return

          // eg. classData: ClassData.fromJson(data['classData']),
          functionReturn.add("      ${fieldName.paramify()}: ${fieldType.classify()}.fromJson(data['$fieldName']),");
        }
      } else {
        if (fieldData.isAList) {
          functionReturn.add("      ${fieldName.paramify()}: ${listOf(fieldType, fieldName)},");
        } else {
          // If this field is not a class or a list
          // it can be referenced easily from the data object
          // TODO although later I would like support for dart classes as well
          functionReturn.add("      ${fieldName.paramify()}: data['$fieldName'],");
        }
      }
    });

    functionReturn.add('    );');

    String functionEnd = "  }";

    this.fromJsonConstructor = [
      ...[functionHead],
      ...functionBody,
      ...functionReturn,
      ...[functionEnd],
    ];
  }

  String listOf(String type, String fieldName) {
    if (type == "String") {
      return " List<String>.from(data['$fieldName'])";
    } else if (type == "int") {
      return " List<int>.from(data['$fieldName'])";
    } else if (type == "double") {
      return " List<double>.from(data['$fieldName'])";
    }
    return '';
  }

  void generateToMap() {
    String functionHead = '  Map<String, dynamic> toMap() {';

    List<String> functionReturn = ['    return {'];

    classData.fieldData.forEach((fieldData) {
      String fieldName = fieldData.name;
      if (fieldData.isAClass) {
        if (fieldData.isAList) {
          functionReturn.add("      '$fieldName': ${fieldName.paramify()}.map((e) => e.toMap()).toList(),");
        } else {
          functionReturn.add("      '$fieldName': ${fieldName.paramify()}.toMap(),");
        }
      } else {
        functionReturn.add("      '$fieldName': ${fieldName.paramify()},");
      }
    });

    functionReturn.add('    };');

    String functionEnd = "  }";

    this.toMapMethod = [
      ...[functionHead],
      ...functionReturn,
      ...[functionEnd]
    ];
  }

  void generateEnd() {
    end.add("}");
  }

  /// TODO: if a class contains an instance of itself, it will loop infinitely generating instances
  /// to fix this, add a third 'generate with data' function that will not add that instance.
  /// not sure how this will work outside of lists of itself?
  /// but for lists it can take a couple children from the generate with data + no kids

  void generateMakeWithDataMethod() {
    // Make with data, singular
    List<String> head = ["  static ${classData.name} makeWithData(List<String> iterations) {"];
    List<String> returnBlock = ["   return ${classData.name}("];
    // loop over fields, add appropriate values to return Block
    classData.fieldData.forEach((fieldData) {
      var type = fieldData.type;
      var name = fieldData.name;
      if (fieldData.isAList && fieldData.isAClass) {
        returnBlock.add("     ${name.paramify()}: $type.makeMultipleWithData(iterations),");
      } else if (fieldData.isAList && !fieldData.isAClass) {
        returnBlock.add("        ${name.paramify()}: ${returnBasicValue(type, name.paramify(), classData.name, fieldData.isAList)},");
      } else if (fieldData.isAClass && !fieldData.isAList) {
        returnBlock.add("     ${name.paramify()}: $type.makeWithData(iterations),");
      } else {
        returnBlock.add("     ${name.paramify()}: ${returnBasicValue(type, name.paramify(), classData.name, fieldData.isAList)},");
      }
    });
    returnBlock.add("  );");
    List<String> end = ['  }'];

    makeWithData = [...head, ...returnBlock, ...end];
  }

  void generateMakeMultipleWithDataMethod() {
    String className = classData.name;
    String classList = "${className.paramify()}List";
    // Make with data, multiple
    List<String> head = ["  static List<$className> makeMultipleWithData(List<String> iterations) {"];
    List<String> body = ["    List<$className> $classList = [];"];
    body.add("      iterations.forEach((x) {");
    body.add("        $classList.add($className(");
    List<String> instantiationFields = [];

    classData.fieldData.forEach((fieldData) {
      var type = fieldData.type;
      var name = fieldData.name;
      if (fieldData.isAList && fieldData.isAClass) {
        instantiationFields.add("        ${name.paramify()}: $type.makeMultipleWithData(iterations),");
      } else if (fieldData.isAList && !fieldData.isAClass) {
        instantiationFields.add("        ${name.paramify()}: ${returnBasicValue(type, name.paramify(), className, fieldData.isAList)},");
      } else if (fieldData.isAClass && !fieldData.isAList) {
        instantiationFields.add("        ${name.paramify()}: $type.makeWithData(iterations),");
      } else {
        instantiationFields.add("        ${name.paramify()}: ${returnBasicValue(type, name.paramify(), className, fieldData.isAList)},");
      }
    });

    body.addAll(instantiationFields);

    body.add("      ));");
    body.add("    });");

    List<String> end = ["   return ${className.paramify()}List;"];
    end.add("  }");

    makeMultipleWithData = [...head, ...body, ...end];
  }

  //
  // ClassRegister instantiateClassRegister() {
  //   return ClassRegister(
  //       classData: classData,
  //       dateModified: DateTime.now().toString().substring(0, 16),
  //       isMainRequest: true);
  // }

  dynamic returnBasicValue(String type, String name, String className, bool isAList) {
    if (isAList) {
      if (type == "String") {
        return ["'$className $name ~ 0'", "'$className $name ~ 1'", "'$className $name ~ 2'"];
      } else if (type == "int") {
        return [3322, 22];
      } else if (type == "double") {
        return [333.22, 22.333, 77.91];
      }
    }
    if (type == "String") {
      return '"$className $name"';
    } else if (type == "int") {
      return 3322;
    } else if (type == "double") {
      return 333.22;
    } else if (type == "bool") {
      return true;
    }
  }
}
