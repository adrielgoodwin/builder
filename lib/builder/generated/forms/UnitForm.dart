import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../data-classes/Unit.dart';

class UnitForm extends StatefulWidget {
  const UnitForm({Key? key}) : super(key: key);
  
  @override
  State<UnitForm> createState() => _UnitFormState();
}

class _UnitFormState extends State<UnitForm> {

  final _formKey = GlobalKey<FormState>();

  late String name; 
  late String symbol; 
  @override
  Widget build(BuildContext context) {
    
    var p = Provider.of<MainProvider>(context);
    
   
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
TextFormField(
    keyboardType: TextInputType.text,
    decoration: const InputDecoration(
      labelText: 'symbol',
    ),
    onSaved: (value) {
      setState(() {
        symbol = value!;
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
  SizedBox(height: 10,),
  ElevatedButton(
    child: Text("Submit"),
    onPressed: () {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();    
        p.addUnit(Unit(
        name: name,
                symbol: symbol,
                
        ));
      }
      _formKey.currentState!.reset();
    },
  ),                
          ],))));
  }
}  
