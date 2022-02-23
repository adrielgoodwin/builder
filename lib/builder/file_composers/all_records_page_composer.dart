import '../models/page_data.dart';
import '../extensions.dart';

/// This is a composer for the page that shows all the records of a given class
/// In tile form,

String allRecordsPageComposer(PageData pageData) {

  var dcp = pageData.dataClass.paramify();
  var dc = pageData.dataClass;

  return '''import 'package:flutter/material.dart';
import '../app_router.dart';
import '../models/$dc';
import '../data.dart';

class ${dc}AllRecordsPage extends StatelessWidget {

  const ${dc}AllRecordsPage({required this.$dcp);
  
  final $dc $dcp;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$dc All Records'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...${dcp}Data.map((e) => ${dcp}TileWidget(e)).toList(),  
          ],
        ),
      ),
    );
  }
  
''';

}