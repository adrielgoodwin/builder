import 'dart:async';

import 'package:builder/builder/presentation/class_maker/class_form.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Classes
import '../../models/class_data.dart';
import '../../models/field_data.dart';

/// Widgets
import 'class_field_input.dart';
import 'result_display.dart';
import 'class_form.dart';
import 'sidebar.dart';
import 'class_editors.dart';

/// Providers
import 'package:builder/builder/state/class_maker_provider.dart';
import 'package:provider/provider.dart';

/// Ui Stuff
import '../../colors/colors.dart';

class ClassMakerScreen extends StatefulWidget {
  const ClassMakerScreen({Key? key}) : super(key: key);

  @override
  _ClassMakerScreenState createState() => _ClassMakerScreenState();
}

class _ClassMakerScreenState extends State<ClassMakerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            /// Sidebar
            Flexible(
              fit: FlexFit.loose,
              flex: 3,
              child: Sidebar(),
            ),
            /// Class editor
            Flexible(
              flex: 9,
              child: ClassEditors(),
            ),
          ],
        ),
      ),
    );
  }
}

