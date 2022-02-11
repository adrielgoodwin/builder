import 'package:flutter/material.dart';
import '../../MetaWidgetTreeBuilder/meta_tree.dart';
import 'package:provider/provider.dart';
import '../../state/meta_widget_builder_provider.dart';
import 'column_parameters.dart';
import 'row_parameters.dart';

class WidgetBuilderSidebar extends StatefulWidget {
  const WidgetBuilderSidebar({Key? key}) : super(key: key);

  @override
  _WidgetBuilderSidebarState createState() => _WidgetBuilderSidebarState();
}

class _WidgetBuilderSidebarState extends State<WidgetBuilderSidebar> {
  Widget widgetManipulator = const Text("click something to edit");

  String focused = "";

  @override
  Widget build(BuildContext context) {
    MetaWidgetBuilderProvider mwbp = Provider.of<MetaWidgetBuilderProvider>(context);
    return Column(
      children: [
        widgetManipulator,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Forks"),
                ...mwbp.metaTree.forkPoints.values.map((e) => forkTile(e)),
                Text("Flexibles"),
                ...mwbp.metaTree.branchNodes.values.map((bn) => flexibleTile(bn as FlexibleNode)).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget flexibleTile(FlexibleNode bn) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              focused = bn.id;
              widgetManipulator = FlexibleManipulator(flexibleNode: bn);
            });
            bn.requestFocus();
          },
          child: Text(bn.id)),
    );
  }

  Widget forkTile(ForkPoint fp) {
    return ElevatedButton(
        onPressed: () {
          if (fp.runtimeType.toString() == 'ColumnFork') {
            setState(() {
              widgetManipulator = ColumnParameters(columnFork: fp as ColumnFork);
            });
          } else if (fp.runtimeType.toString() == 'RowFork') {
            setState(() {
              widgetManipulator = RowParameters(rowFork: fp as RowFork);
            });
          }
        },
        child: Text(fp.id));
  }
}

class FlexibleManipulator extends StatefulWidget {
  const FlexibleManipulator({Key? key, required this.flexibleNode}) : super(key: key);

  final FlexibleNode flexibleNode;

  @override
  _FlexibleManipulatorState createState() => _FlexibleManipulatorState();
}

class _FlexibleManipulatorState extends State<FlexibleManipulator> {
  @override
  Widget build(BuildContext context) {
    var fn = widget.flexibleNode;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            fn.addChildColumn();
          },
          child: const Text("add child column"),
        ),
        ElevatedButton(
          onPressed: () {
            fn.addChildRow();
          },
          child: const Text("add child row"),
        ),
        IconButton(
          onPressed: () => fn.increaseSize(),
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () => fn.decreaseSize(),
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
