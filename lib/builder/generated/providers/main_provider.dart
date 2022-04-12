import 'package:flutter/cupertino.dart';
import '../data-classes/InventoryItem.dart';
import '../data-classes/Unit.dart';
import '../data-classes/Recipe.dart'; 

class MainProvider with ChangeNotifier {
  ///_____________________________
  /// InventoryItem 
  
  Map<String, InventoryItem> _inventoryItems = {};

  List<InventoryItem> get getInventoryItems => _inventoryItems.values.toList();

  InventoryItem getInventoryItem(String name) => _inventoryItems[name]!;

  List<InventoryItem> getInventoryItemsByName(String string) {
    return _inventoryItems.values.where((inventoryItem) => inventoryItem.name.substring(0, string.length) == string).toList();
  }
  
  List<InventoryItem> getInventoryItemsListByNameList(List<String> names) {
    return getInventoryItems.where((element) => names.contains(element.name)).toList();
  }

  void addInventoryItem(InventoryItem inventoryItem) {
    _inventoryItems.addAll({inventoryItem.name: inventoryItem});
    notifyListeners();
  }

  void removeInventoryItems(InventoryItem inventoryItem) {
    _inventoryItems.remove(inventoryItem.name);
    notifyListeners();
  }  
   ///_____________________________
  /// Unit 
  
  Map<String, Unit> _units = {};

  List<Unit> get getUnits => _units.values.toList();

  Unit getUnit(String name) => _units[name]!;

  List<Unit> getUnitsByName(String string) {
    return _units.values.where((unit) => unit.name.substring(0, string.length) == string).toList();
  }
  
  List<Unit> getUnitsListByNameList(List<String> names) {
    return getUnits.where((element) => names.contains(element.name)).toList();
  }

  void addUnit(Unit unit) {
    _units.addAll({unit.name: unit});
    notifyListeners();
  }

  void removeUnits(Unit unit) {
    _units.remove(unit.name);
    notifyListeners();
  }  
   ///_____________________________
  /// Recipe 
  
  Map<String, Recipe> _recipes = {};

  List<Recipe> get getRecipes => _recipes.values.toList();

  Recipe getRecipe(String name) => _recipes[name]!;

  List<Recipe> getRecipesByName(String string) {
    return _recipes.values.where((recipe) => recipe.name.substring(0, string.length) == string).toList();
  }
  
  List<Recipe> getRecipesListByNameList(List<String> names) {
    return getRecipes.where((element) => names.contains(element.name)).toList();
  }

  void addRecipe(Recipe recipe) {
    _recipes.addAll({recipe.name: recipe});
    notifyListeners();
  }

  void removeRecipes(Recipe recipe) {
    _recipes.remove(recipe.name);
    notifyListeners();
  }  
 }