import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../data-classes/Thingy.dart';

import '../io_app/widgets/singleSearch.dart';
import '../data-classes/InventoryItem.dart';class ThingyForm extends StatefulWidget {
  const ThingyForm({Key? key}) : super(key: key);
  
  @override
  State<ThingyForm> createState() => _ThingyFormState();
}

class _ThingyFormState extends State<ThingyForm> {

  final _formKey = GlobalKey<FormState>();

  late String name; 
  late InventoryItem inventoryItem; 
  @override
  Widget build(BuildContext context) {
    
    var p = Provider.of<MainProvider>(context);
    var existingInventoryItems = p.getInventoryItems.map((e) => e.name).toList();

   
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
    SingleSearch(dataSet: existingInventoryItems, label: 'Choose a inventoryItem', resultCallback: (value) {
      setState(() {
        inventoryItem = p.getInventoryItem(value);
      });
    }),
  SizedBox(height: 10,),
  ElevatedButton(
    child: Text("Submit"),
    onPressed: () {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();    
        p.addThingy(Thingy(
        name: name,
                inventoryItem: inventoryItem,
                
        ));
      }
      _formKey.currentState!.reset();
    },
  ),                
          ],))));
  }
}  
