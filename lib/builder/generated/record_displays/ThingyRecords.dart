import 'package:flutter/material.dart';
import '../providers/main_provider.dart';
import 'package:provider/provider.dart';
import '../../models/nameValueType.dart';
import '../data-classes/Thingy.dart';
import '../forms/ThingyForm.dart';
import '../io_app/widgets/recordDisplays.dart';

class ThingyRecords extends StatefulWidget {
  const ThingyRecords({Key? key}) : super(key: key);

  @override
  State<ThingyRecords> createState() => _ThingyRecordsState();
}

class _ThingyRecordsState extends State<ThingyRecords> {

  @override
  Widget build(BuildContext context) {
    var s = Provider.of<MainProvider>(context);
    /// this
    var x = s.getThingys;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          records(x),
        ],
      ),
    );
  }
  Widget records(List<Thingy> x) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: 
                  x.isNotEmpty ? x.map((e) => recordCard(e.fieldsAndValues)).toList() : [Center(child: Text('Nothin here. LongPress to open form', style: TextStyle(fontSize: 33),),)]
                 ,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Widget recordCard(List<NameValueType> nvt) {
  /// implement type later for different displays
  /// more metadata for more display differences,
  /// eg. a row with two small values together /// or not, just do it with the widget builder?
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
