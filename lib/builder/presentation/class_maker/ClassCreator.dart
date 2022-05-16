import 'package:builder/builder/state/global_input_provider.dart';
import 'package:flutter/material.dart';

// Provider
import 'package:provider/provider.dart';
import '../../state/focusProvider.dart';
import '../../state/class_maker_provider.dart';
import '../../state/classProvider.dart';
import 'new_class_display.dart';

// Actions
import '../../actions/classMakerActions.dart';

class ClassCreator extends StatelessWidget {
  const ClassCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fProv = Provider.of<FocusProvider>(context);
    var cmp = Provider.of<ClassMakerProvider>(context);
    var gip = Provider.of<GlobalInputProvider>(context);
    var cp = Provider.of<ClassProvider>(context);
    var cfa = ClassFormActions(fProv, cmp, gip, cp);
    return Column(
      children: [
        Shortcuts(
          shortcuts: cfa.shortcuts,
          child: Actions(
            actions: cfa.actions,
            child: Focus(
              onFocusChange: (change) => print(change),
              focusNode: fProv.CC,
              child: const NewClassDisplay(),
            ),
          ),
        ),
      ],
    );
  }
}
