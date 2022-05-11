// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/// Sections
import 'class_maker/classMakerSection.dart';
// Provider
import 'package:provider/provider.dart';
import '../state/focusProvider.dart';
import '../state/global_input_provider.dart';
// Actions
import '../actions/topActions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController globalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Homescreen Rebuilt");
    var gprov = Provider.of<GlobalInputProvider>(context);
    var fProv = Provider.of<FocusProvider>(context);
    var topActions = TopActions(fProv);
    fProv.TOP.requestFocus();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app_outlined)),
        ],
        title: Opacity(
          opacity: gprov.visible,
          child: TextField(
            controller: globalController,
            focusNode: gprov.focusNode,
            onChanged: (val) => gprov.function(val),
            onSubmitted: (_) {
              gprov.previousFocus.requestFocus();
              globalController.clear();
            },
          ),
        ),
      ),
      body: GestureDetector(
        onTap: fProv.TOP.requestFocus,
        child: AbsorbPointer(
          absorbing: true,
          child: Shortcuts(
            shortcuts: topActions.shortcuts,
            child: Actions(
              actions: topActions.actions,
              child: Focus(
                focusNode: fProv.TOP,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Flexible(
                        flex: 3,
                        child: ClassMakerSection(),
                      ),
                      Flexible(child: Text("""Focus node to classname, increase size a little bit too. 
                      consider how to make the key binding groups for each sections
                      """)),
                      Flexible(child: Text("Display"),)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
