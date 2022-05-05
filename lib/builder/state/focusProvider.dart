// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/cupertino.dart';

class FocusProvider with ChangeNotifier {

  /// TopFocus

  final _TOP = FocusNode();

  FocusNode get TOP => _TOP;

  /// ClassMaker

  final _CM = FocusNode();

  FocusNode get CM => _CM;

  // Fields in new class maker
  Map<String, FocusNode> fields = {};
  void addFieldNode(String id, FocusNode node) => fields[id] = node;



  /// WidgetMaker

  /// Display


}
