import 'package:flutter/material.dart';

class MultiSearch extends StatefulWidget {
  const MultiSearch({Key? key, required this.dataSet, required this.label, required this.resultCallback}) : super(key: key);

  final List<String> dataSet;
  final Function resultCallback;
  final String label;

  @override
  State<MultiSearch> createState() => _MultiSearchState();
}

class _MultiSearchState extends State<MultiSearch> {

  /// chain of events:
  /// User: types into box ~ Program: calls search and display
  ///   `setState`: searchResults by filtering dataSet with search ~ result textButtons update
  /// User: selects a result ~ Program: calls select result

  void searchAndDisplay(String searchValue) {
    setState(() {
      /// check if search is empty so theres no 'left-overs'
      if(searchValue.isEmpty) {
        searchResults = widget.dataSet;
      } else {
        searchResults = widget.dataSet.where((item) {
          /// filter out anything too short
          if(item.length < searchValue.length) {
            return false;
          } else {
            /// make the check
            return item.substring(0, searchValue.length) == searchValue ? true : false;
          }
        }).toList();
      }
    });
  }

  void manualEnter(String value) {
    if(widget.dataSet.contains(value)){
      selectResult(value);
    } else {
      setError('An Item by this name does not exist... yet');
    }
  }

  void selectResult(String e) {
      setState(() {
        selectedResults.add(e);
        searchResults.remove(e);
      });
      widget.resultCallback(selectedResults);
  }

  @override
  void initState() {
    super.initState();
    searchResults = widget.dataSet;
  }

  List<String> searchResults = [];

  List<String> selectedResults = [];

  bool lockedIn = false;

  String errorMessage = "";

  void setError(String error) => setState(() {
    errorMessage = error;
  });

  var controller = TextEditingController();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              /// Search box or Result when it has been selected
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: widget.label,
                  ),
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: manualEnter,
                  onChanged: (value) => searchAndDisplay(value),
                ),
              ),
              /// Search Icon, green when searching, yellow when item has been selected
              /// To re-activate search box, click on icon
              // SizedBox(width: 25, height: 25, child: IconButton(onPressed: () => setState(() {
              //   lockedIn = false;
              //   controller.text = selectedResult;
              //   focusNode.requestFocus();
              // }), icon: Icon(Icons.search, color: lockedIn ? Colors.amber : Colors.green, size: 20,),),)
            ],
          ),
        ),

        /// Selected Items ~~~
        selectedResults.isNotEmpty ? selectedResultsBox(selectedResults) : SizedBox(),

        /// Error message
        errorMessage.isNotEmpty ? Text(errorMessage) : const SizedBox(),
        /// Results of search
        ...searchResults.map((e) => TextButton(onPressed: () => selectResult(e), child: Text(e))).toList(),
      ],
    );
  }
  
  Widget selectedResultsBox(List<String> selectedResults) {
    return Column(
      children: [
        ...selectedResults.map((e) => selectedResultTile(e)).toList(),
      ],
    );
  }
  
  Widget selectedResultTile(String selection) {
    return Row(
      children: [
        Text(selection),
        IconButton(onPressed: () => setState(() {
          selectedResults.remove(selection);
        }), icon: const Icon(Icons.remove, color: Colors.red,))
      ],
    );
  }
  
}
