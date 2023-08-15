import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/state.dart';

class UISection extends StatelessWidget {
  const UISection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AllState>(context);
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          height: 500,
          width: 500,
          child: SingleChildScrollView(
              child: Column(
            children: [
              // state.usedIElements,
            ],
          )),
        ),
        SingleChildScrollView(
          child: Column(
            // children: state.UIElements,
          ),
        )
      ],
    );
  }
}

class SimpleWidgy extends StatelessWidget {
  const SimpleWidgy(
      {required this.var1, required this.var2, required this.var3, Key? key})
      : super(key: key);

  final String var1;
  final String var2;
  final String var3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 150,
      child: Column(children: [
        Row(
          children: [
            Text(var1,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                )),
            Text(var2,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                )),
          ],
        ),
        Text(
          var3,
          style: TextStyle(fontSize: 12),
        )
      ]),
    );
  }
}
