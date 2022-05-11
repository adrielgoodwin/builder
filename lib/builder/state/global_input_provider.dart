import 'package:flutter/material.dart';

class GlobalInputProvider with ChangeNotifier {
  double _visible = 0;

  double get visible => _visible;

  void setVisibility(double visibility) {
    _visible = visibility;
    notifyListeners();
  }

  late Function function;

  void setFunction(Function fn) => function = fn;

  final _focusNode = FocusNode();

  FocusNode get focusNode => _focusNode;

  late FocusNode _previousFocus;

  FocusNode get previousFocus => _previousFocus;

  void setPreviousFocus(FocusNode fn) => _previousFocus = fn;

  void focus(FocusNode previousFocus) {
    _focusNode.requestFocus();
    setPreviousFocus(previousFocus);
  }

}
