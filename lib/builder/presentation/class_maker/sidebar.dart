import 'package:flutter/material.dart';
import '../../colors/colors.dart';

// Provider
import 'package:provider/provider.dart';
import '../../state/class_maker_provider.dart';

// Models
import '../../models/class_data.dart';

// Widgets
import 'sidebar_class_navigator.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ClassMakerProvider>(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: C.lightGray,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(onPressed: () => state.loadRegistries(), child: const Text("load classes")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Classes",
                  style: TextStyle(fontSize: 26),
                ),
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            ...state.existingClasses.map((e) => SidebarClassNavigator(classData: e)),
          ],
        ),
      ),
    );
  }
}
