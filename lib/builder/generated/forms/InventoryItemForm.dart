import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../data-classes/InventoryItem.dart';

import '../io_app/widgets/singleSearch.dart';
import '../data-classes/Unit.dart';class InventoryItemForm extends StatefulWidget {
  const InventoryItemForm({Key? key}) : super(key: key);
  
  @override
  State<InventoryItemForm> createState() => _InventoryItemFormState();
}

class _InventoryItemFormState extends State<InventoryItemForm> {

  final _formKey = GlobalKey<FormState>();

  late String name; 
  late int price; 
  late Unit unit; 
  @override
  Widget build(BuildContext context) {
    
    var p = Provider.of<MainProvider>(context);
    var existingUnits = p.getUnits.map((e) => e.name).toList();

   
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
      keyboardType: TextInputType.number,
      onSaved: (value) {
        setState(() {
          price = int.parse(value!);
        });
      },
      decoration: const InputDecoration(
        labelText: 'price',
      ),
    ),
      SingleSearch(dataSet: existingUnits, label: 'Choose a unit', resultCallback: (value) {
      setState(() {
        unit = p.getUnit(value);
      });
    }),
  SizedBox(height: 10,),
  ElevatedButton(
    child: Text("Submit"),
    onPressed: () {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();    
        p.addInventoryItem(InventoryItem(
        name: name,
                price: price,
                unit: unit,
                
        ));
      }
      _formKey.currentState!.reset();
    },
  ),                
          ],))));
  }
}  