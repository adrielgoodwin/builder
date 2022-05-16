// import 'package:flutter/material.dart';
// import '../../models/field_data.dart';
// import '../../models/class_data.dart';
// import '../../MetaWidgetTreeBuilder/meta_tree.dart';
// import '../../state/classProvider.dart';
// import 'package:provider/provider.dart';
//
// /// Ui Stuff
// import '../../colors/colors.dart';
//
// class TextParameters extends StatefulWidget {
//   const TextParameters({Key? key, required this.textLeaf}) : super(key: key);
//
//   final TextLeaf textLeaf;
//
//   @override
//   _TextParametersState createState() => _TextParametersState();
// }
//
// class _TextParametersState extends State<TextParameters> {
//   MetaTextParams mtp = MetaTextParams(id: '', textStyle: MetaTextStyle());
//
//   TextStyle textStyle = const TextStyle();
//
//   List<FontWeight> boldness = [
//     FontWeight.w100,
//     FontWeight.w200,
//     FontWeight.w300,
//     FontWeight.w400,
//     FontWeight.w500,
//     FontWeight.w600,
//     FontWeight.w700,
//     FontWeight.w800,
//   ];
//
//   Map<String, double> sizes = {
//     "Tiny": 6,
//     "Small": 8,
//     "Almost There": 10,
//     "Normal": 12,
//     "Subtitle": 16,
//     "Title": 18,
//     "Header": 20,
//     "Massive": 26,
//   };
//
//   bool isItalic = false;
//
//   List<TextButton> makeSizeButtons() {
//     List<TextButton> butts = [];
//     sizes.forEach((key, value) {
//       butts.add(TextButton(
//           child: Text(key, style: TextStyle(fontSize: value, color: mtp.textStyle.fontSize == value ? Colors.green : Colors.grey)),
//           onPressed: () => setState(() {
//                 mtp.textStyle.fontSize = value;
//                 widget.textLeaf.updateStyle(mtp.textStyle);
//               })));
//     });
//     return butts;
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     var classState = Provider.of<ClassProvider>(context);
//     var nac = classState.existingClasses;
//
//     return Container(
//       child: Column(
//         children: [
//           Wrap(
//             alignment: WrapAlignment.center,
//             children: [
//               ...boldness
//                   .map((x) => TextButton(
//                         child: Text("howBold?", style: TextStyle(fontWeight: x, color: x == mtp.textStyle.weight ? Colors.green : Colors.grey)),
//                         onPressed: () => setState(() {
//                           mtp.textStyle.weight = x;
//                           widget.textLeaf.updateStyle(mtp.textStyle);
//                         }),
//                       ))
//                   .toList(),
//             ],
//           ),
//           Wrap(
//             alignment: WrapAlignment.center,
//             children: makeSizeButtons(),
//           ),
//           TextButton(onPressed: () => setState(() {
//             isItalic = !isItalic;
//             mtp.textStyle.style = isItalic ? FontStyle.italic : FontStyle.normal;
//             widget.textLeaf.updateStyle(mtp.textStyle);
//           }), child: Text(isItalic ? "Italicised" : "Italicise", style: TextStyle(fontStyle: isItalic ? FontStyle.italic : FontStyle.normal, color: isItalic ? Colors.green : Colors.black87)))
//         ],
//       ),
//     );
//   }
//
//   Widget sidebarClassItem(ClassData classData, ClassMakerProvider state) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {
//
//             },
//             child: Text(
//               classData.name,
//               style: TextStyle(fontSize: 16, color: C.orange, fontWeight: FontWeight.w500),
//             ),
//           ),
//           ...classData.fieldData.map((e) {
//             return Row(
//               children: [
//                 Text(
//                   "  ${e.type}",
//                   style: TextStyle(color: C.teal, fontWeight: FontWeight.w400),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       mtp.fieldData = e;
//                       widget.textLeaf.updateField(mtp.fieldData!);
//                     });
//                   },
//                   child: Text(
//                     "  ${e.name}",
//                     style: TextStyle(color: C.purple.withOpacity(0.5), fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
// }
