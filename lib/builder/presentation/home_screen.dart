import 'package:flutter/material.dart';
/// Sections
import 'class_maker/class_editors.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app_outlined)),
        ],
        title: Text("AppMaker"),
      ),
      body: Row(
        children: [
          Flexible(
            child: ClassEditors(),
          ),
        ],
      ),
    );
  }
}
