import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/state.dart';

class UISection extends StatelessWidget {
  const UISection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AllState>(context);
    return SizedBox(height: 900, width: 400, child: Text(""),);
  }
}