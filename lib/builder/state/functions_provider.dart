
import 'package:flutter/cupertino.dart';

class FunctionsProvider with ChangeNotifier {

  String _newPageText = "";
  void setNewPageText(String text) => _newPageText = text;
  String get newPageText => _newPageText;

}