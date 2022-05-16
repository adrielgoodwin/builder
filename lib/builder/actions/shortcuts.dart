import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdi/mdi.dart';

enum ActionArea { classSection, classMaker, classSelector }

enum FieldMakerActions {
  setTypeToString,
  setTypeToInt,
  setTypeToDouble,
  setTypeToDateTime,
  setTypeToClass
}

// Map<FieldMakerActions, >

// Map<List<LogicalKeyboardKey> > keyIconMap = {
//   LogicalKeyboardKey.shift: Icon(Mdi.appleKeyboardShift)
// };