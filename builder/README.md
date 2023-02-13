# Flutter Builder

## TO DO 

1. Generate input forms for classes.
  Data-type dependant form generation with a managed state. 

###### A flutter app that builds flutter apps

## NO MORE BUTTONS... lol 

I've decided to simplify the user interaction by deleting all the buttons.   
Now the only way to do anything is by using your keyboard.  

This works by having an 'action socket' which is filled with an 'action plug'.  
```
/lib/builder/actions/actionsSocket.dart
```
In essence, an action plug is just a class that takes a bunch of functions as parameters and maps them to a specific keypress.  

This then allows for the same keys to be re-used as buttons, depending on 'where' in the app the user is, simply by setting the current action plug.  

## ALL STATE IN ONE SPOT! 

I've moved the state to be in one file. I don't know why people in videos always make multiple state files, when it really just makes things more complicated than it needs to be.  
```
/lib/builder/state/state.dart
```
Now every possible action and all the data for those actions are organized nicely in one file.   
Using the action sockets it is quite easy to add functionality, with access to everything that already exists.

## GLOBAL INPUT 

At the bottom of the state file you will see a text input with a settable function.   
This allows us to recieve text input from the user at any point of our application.
```
  FocusNode textInputFocus = FocusNode();
  TextEditingController textController = TextEditingController();
  Function textInputFunction = () {};
  void setTextInputFunction(Function fn) {
    textInputFunction = fn;
    textController.clear();
    notifyListeners();
  }
```

It is then placed in the widget tree.  
The most important thing to note here is onChanged.
```
TextField(
    focusNode: state.textInputFocus,
    controller: state.textController,
    onChanged: (val) => state.textInputFunction(val),
    onSubmitted: (_) {state.rawkeyFocus.requestFocus(); state.textController.clear();},
),
```   
For example, we can use **actionL** in our **ActionPlug** to first *focus* the textInput, then *set the functionality* to change the name of a field in a class. 
```
    void setFieldName(String name) {
        var field = selectedField;
        field.name = name.paramify();
        setField(field);
    }

    ...
    actionl: () {
        textInputFocus.requestFocus(); // Focus our input
        setTextInputFunction(setFieldName); // Set its functionality to previously defined function
    },
    ...

```


