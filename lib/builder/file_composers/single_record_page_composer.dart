import '../models/page_data.dart';

import '../extensions.dart';

String composeSingleRecordPage(PageData pageData) {

  var dcp = pageData.dataClass.paramify();
  var dc = pageData.dataClass;

  return '''import 'package:flutter/material.dart';
import '../app_router.dart';
import '../models/$dc';

class ${dc}Page extends StatelessWidget {

  const ${dc}Page({required this.$dcp);
  
  final $dc $dcp;

  static Future<void> show(
      {required BuildContext context, required $dc $dcp}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.${dcp}Page,
      arguments: {
        '$dcp': $dcp,
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$dc Single Record'),
      ),
      body: SingleChildScrollView(
        child: {$dc}SinglePage($dcp),
      ),
    );
  }
  
''';

}


