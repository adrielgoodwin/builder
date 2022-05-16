// ignore_for_file: non_constant_identifier_names

import 'package:builder/builder/state/global_input_provider.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

// Colors
import '../../colors/colors.dart';

// Nice widgets
import '../../someWidgets.dart';

// Providers
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';
import '../../state/focusProvider.dart';

// Actions
import '../../actions/classMakerActions.dart';

// Models
import '../../models/class_data.dart';

// Composer
import '../../file_composers/composerFunctions.dart';

// Sections
import 'ClassCreator.dart';

class ClassMakerSection extends StatefulWidget {
  const ClassMakerSection({Key? key}) : super(key: key);

  @override
  State<ClassMakerSection> createState() => _ClassMakerSectionState();
}

class _ClassMakerSectionState extends State<ClassMakerSection> {


  void tryWritingClass(ClassMakerProvider prov) async {
    showToast("Could not be added at the moment!");
    // var classWritten = await writeClass(prov.newClass);
    // if (classWritten) {
    //   prov.beginNewClass();
    // } else {
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Providers
    var fProv = Provider.of<FocusProvider>(context);
    var cmp = Provider.of<ClassMakerProvider>(context);
    var gip = Provider.of<GlobalInputProvider>(context);
    var isMakingNewClass = Provider.of<ClassMakerProvider>(context).isMakingNewClass;
    // Actions
    var CMA = ClassMakerActions(fProv, cmp);
    // New form height adjustment
    var amtOfFields =
        Provider.of<ClassMakerProvider>(context).elClass.fieldData.length;
    var height = MediaQuery.of(context).size.height - 54;
    var classBoxHeight = 0.0;
    if (isMakingNewClass) {
      var newHeight = amtOfFields * 50 + 60;
      if (newHeight < height) {
        classBoxHeight = newHeight * 1.0;
      } else {
        classBoxHeight = height;
      }
    }

    return Shortcuts(
      shortcuts: CMA.shortcuts,
      child: Actions(
        actions: CMA.actions,
        child: Focus(
          focusNode: fProv.CMS,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: C.lightGray,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    decoration: BoxDecoration(
                      border: Border.all(color: C.darkGray),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: classBoxHeight,
                    child: const SingleChildScrollView(child: ClassCreator()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// broken locomotion, woken soaked with sad emotions
