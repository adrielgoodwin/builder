import 'package:flutter/material.dart';

class DataWidgetRelation {

  final String className;
  final List<Widget> listViewWidgets;
  final List<Widget> mediumViewWidgets;
  final List<Widget> fullPageWidgets;

  DataWidgetRelation({required this.className, required this.listViewWidgets, required this.mediumViewWidgets, required this.fullPageWidgets});

}