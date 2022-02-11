import 'package:builder/builder/MetaWidgetTreeBuilder/meta_tree.dart';
import 'package:flutter/material.dart';
import '../../MetaWidgetTreeBuilder/meta_tree.dart';
import '../../state/meta_widget_builder_provider.dart';
import 'package:provider/provider.dart';

class ColumnParameters extends StatefulWidget {
  const ColumnParameters({Key? key, required this.columnFork}) : super(key: key);

  final ColumnFork columnFork;

  @override
  _ColumnParametersState createState() => _ColumnParametersState();
}

class _ColumnParametersState extends State<ColumnParameters> {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween;
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;

  TextStyle titleStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  Map<String, MainAxisAlignment> ma = {
    "start": MainAxisAlignment.start,
    "space evenly": MainAxisAlignment.spaceEvenly,
    "center": MainAxisAlignment.center,
    "space between": MainAxisAlignment.spaceBetween,
  };

  Map<String, CrossAxisAlignment> xa = {
    "start": CrossAxisAlignment.start,
    "stretch": CrossAxisAlignment.stretch,
    // "baseline": CrossAxisAlignment.baseline,
    "center": CrossAxisAlignment.center,
    "end": CrossAxisAlignment.end,
  };

  @override
  Widget build(BuildContext context) {

    var cf = widget.columnFork;

    var metaBuilderState = Provider.of<MetaWidgetBuilderProvider>(context);

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Column Parameters", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Main Axis Alignment",
                        style: titleStyle,
                      ),
                      ...maOptions(metaBuilderState, widget.columnFork),
                      Divider(),
                      Text(
                        "Cross Axis Alignment",
                        style: titleStyle,
                      ),
                      ...xaOptions(metaBuilderState, widget.columnFork),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(
                      mainAxisAlignment: mainAxisAlignment,
                      crossAxisAlignment: crossAxisAlignment,
                      children: [circle(), circle(), circle()],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(onPressed: () {
            cf.addChildFlexible();
          }, child: Text("Add Flexible")),
        ],
      ),
    );
  }

  List<Widget> xaOptions(MetaWidgetBuilderProvider mwbp, ColumnFork columnFork) {
    List<Widget> xaOptions = [];
    xa.forEach((key, value) {
      var widget = GestureDetector(
        child: Text(
          key,
          style: TextStyle(color: crossAxisAlignment == value ? Colors.blueAccent : Colors.black87),
        ),
        onTap: () {
          setState(() {
            crossAxisAlignment = value;
            columnFork.params.crossAxisAlignment = value;
            mwbp.addUpdateForks([columnFork]);
          });
        },
      );
      xaOptions = [...xaOptions, widget];
    });
    return xaOptions;
  }

  List<Widget> maOptions(MetaWidgetBuilderProvider mwbp, ColumnFork columnFork) {
    List<Widget> maOptions = [];
    ma.forEach((key, value) {
      var widget = GestureDetector(
        child: Text(
          key,
          style: TextStyle(color: mainAxisAlignment == value ? Colors.blueAccent : Colors.black87),
        ),
        onTap: () {
          setState(() {
            mainAxisAlignment = value;
            columnFork.params.mainAxisAlignment = value;
            mwbp.addUpdateForks([columnFork]);
          });
        },
      );
      maOptions = [...maOptions, widget];
    });
    return maOptions;
  }

  Widget circle() {
    return Container(
      width: 15,
      height: 15,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
    );
  }
}
