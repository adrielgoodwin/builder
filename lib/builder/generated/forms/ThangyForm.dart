import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../data-classes/Thangy.dart';

import '../io_app/widgets/singleSearch.dart';
import '../io_app/widgets/multiSearch.dart';
import '../data-classes/Thingy.dart';class ThangyForm extends StatefulWidget {
  const ThangyForm({Key? key}) : super(key: key);
  
  @override
  State<ThangyForm> createState() => _ThangyFormState();
}

class _ThangyFormState extends State<ThangyForm> {

  final _formKey = GlobalKey<FormState>();

  late String name; 
  late List<Thingy> thingies; 
  @override
  Widget build(BuildContext context) {
    
    var p = Provider.of<MainProvider>(context);
    var existingThingys = p.getThingys.map((e) => e.name).toList();

   
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
TextFormField(
    keyboardType: TextInputType.text,
    decoration: const InputDecoration(
      labelText: 'name',
    ),
    onSaved: (value) {
      setState(() {
        name = value!;
      });
    },
    // The validator receives the text that the user has entered.
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
  ),
    MultiSearch(dataSet: existingThingys, label: 'Choose a few thingiess', resultCallback: (value) {
      setState(() {
        thingies = p.getThingysListByNameList(value);
      });
    }),
  SizedBox(height: 10,),
  ElevatedButton(
    child: Text("Submit"),
    onPressed: () {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();    
        p.addThangy(Thangy(
        name: name,
                thingies: thingies,
                
        ));
      }
      _formKey.currentState!.reset();
    },
  ),                
          ],))));
  }
}  
