import '../../models/nameValueType.dart';

import "InventoryItem.dart";
// This code was generated on 2022-04-11 18:48
// class
class Recipe {
  // fields
  final String name;
  final String description;
  final List<InventoryItem> ingredients;
  // fields end
  Recipe({required this.name, required this.description, required this.ingredients});
  factory Recipe.fromJson(Map<String, dynamic> data) {
    var ingredientsList = data['ingredients'];
    List<InventoryItem> listOfInventoryItem = [];
    for(var i = 0; i < ingredientsList.length; i++){
      listOfInventoryItem.add(InventoryItem.fromJson(ingredientsList[i]));
    }
    return Recipe(
      name: data['name'],
      description: data['description'],
      ingredients: listOfInventoryItem,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
    };
  }
  List<NameValueType> get fieldsAndValues => [

      NameValueType('name', name, 'String', false, false), 

      NameValueType('description', description, 'String', false, false), 

      NameValueType('ingredients', ingredients.map((e) => '${e.name}').toList() , 'InventoryItem', true, true), 

  ];
  static Recipe makeWithData(List<String> iterations) {
   return Recipe(
     name: "Recipe name",
     description: "Recipe description",
     ingredients: InventoryItem.makeMultipleWithData(iterations),
  );
  }
  static List<Recipe> makeMultipleWithData(List<String> iterations) {
    List<Recipe> recipeList = [];
      iterations.forEach((x) {
        recipeList.add(Recipe(
        name: "Recipe name",
        description: "Recipe description",
        ingredients: InventoryItem.makeMultipleWithData(iterations),
      ));
    });
   return recipeList;
  }
}