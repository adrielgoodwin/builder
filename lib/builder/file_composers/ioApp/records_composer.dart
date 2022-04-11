import '../../models/class_data.dart';

String composeRecordsPage(ClassData classData) {

  var className = classData.name;

  var imports = """import 'package:flutter/material.dart';
import '../providers/main_provider.dart';
import 'package:provider/provider.dart';
import '../../models/nameValueType.dart';
import '../data-classes/$className.dart';
import '../forms/${className}Form.dart';
import '../io_app/widgets/recordDisplays.dart';

""";



  var widgetHead = """class ${className}Records extends StatefulWidget {
  const ${className}Records({Key? key}) : super(key: key);

  @override
  State<${className}Records> createState() => _${className}RecordsState();
}

class _${className}RecordsState extends State<${className}Records> {
  bool formIsVisible = false;

  void openForm() => setState(() {
        formIsVisible = true;
      });

  void closeForm() => setState(() {
        formIsVisible = false;
      }); 
""";
  var buildMethod = """  @override
  Widget build(BuildContext context) {
    var s = Provider.of<MainProvider>(context);
    /// this
    var x = s.get${className}s;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          records(x),
          form(formIsVisible),
        ],
      ),
    );
  }
""";

  var form = """  Widget form(bool visibility) {
    return Visibility(
      /// this
      child: ${className}Form(
        submitCallback: closeForm,
      ),
      visible: visibility,
    );
  }
""";

  var recordsWidget = """  Widget records(List<$className> x) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...x.map((e) => recordCard(e.fieldsAndValues)).toList()
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              child: Text("Add new $className}"),
              onPressed: openForm,
            ),
          )
        ],
      ),
    );
  }
}
""";

  var recordCard = """Widget recordCard(List<NameValueType> nvt) {
  /// implement type later for different displays
  /// more metadata for more display differences,
  /// eg. a row with two small values together
  /// or not, just do it with the widget builder?
  return Card(
    shadowColor: Colors.amber,
    child: SizedBox(
      width: double.infinity,
      child: Column(
        /// todo show type
        children: [
          ...nvt
              .map(
                (e) {
                  if (e.isAList) {
                    return isAListDisplay(e);
                  } else {
                    return isNotAListDisplay(e);
                  }
                }
              )
              .toList()
        ],
      ),
    ),
  );
}
""";

  return [imports, widgetHead, buildMethod, form, recordsWidget, recordCard].join();

}