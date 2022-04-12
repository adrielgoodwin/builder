import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import '../data-classes/Recipe.dart';

import '../io_app/widgets/singleSearch.dart';
import '../io_app/widgets/multiSearch.dart';
import '../data-classes/InventoryItem.dart';class RecipeForm extends StatefulWidget {
  const RecipeForm({Key? key}) : super(key: key);
  
  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {

  final _formKey = GlobalKey<FormState>();

  late String name; 
  late String description; 
  late List<InventoryItem> ingredients; 
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
TextFormField(
    keyboardType: TextInputType.text,
    decoration: const InputDecoration(
      labelText: 'description',
    ),
    onSaved: (value) {
      setState(() {
        description = value!;
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
    MultiSearch(dataSet: existingInventoryItems, label: 'Choose a few ingredientss', resultCallback: (value) {
      setState(() {
        ingredients = p.getInventoryItemsListByNameList(value);
      });
    }),
  SizedBox(height: 10,),
  ElevatedButton(
    child: Text("Submit"),
    onPressed: () {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();    
        p.addRecipe(Recipe(
        name: name,
                description: description,
                ingredients: ingredients,
                
        ));
      }
      _formKey.currentState!.reset();
    },
  ),                
          ],))));
  }
}  
