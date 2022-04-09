import 'package:flutter/material.dart';

class SingleSearch extends StatefulWidget {
  const SingleSearch({Key? key, required this.dataSet, required this.resultCallback}) : super(key: key);

  final List<String> dataSet;
  final Function resultCallback;

  @override
  State<SingleSearch> createState() => _SingleSearchState();
}

class _SingleSearchState extends State<SingleSearch> {

  /// chain of events:
  /// User: types into box ~ Program: calls search and display
  ///   `setState`: searchResults by filtering dataSet with search ~ result textButtons update
  /// User: selects a result ~ Program: calls select result

  void searchAndDisplay(String searchValue) {
    setState(() {
      /// check if search is empty so theres no 'left-overs'
      if(searchValue.isEmpty) {
        searchResults = [];
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
      selectedResult = e;
      lockedIn = true;
      searchResults = [];
    });
    widget.resultCallback(e);
  }

  List<String> searchResults = [];

  String selectedResult = "";

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
                child: lockedIn ? Text(selectedResult) : TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: manualEnter,
                  onChanged: (value) => searchAndDisplay(value),
                ),
              ),
              /// Search Icon, green when searching, yellow when item has been selected
              /// To re-activate search box, click on icon
              SizedBox(width: 25, height: 25, child: IconButton(onPressed: () => setState(() {
                lockedIn = false;
                controller.text = selectedResult;
                focusNode.requestFocus();
              }), icon: Icon(Icons.search, color: lockedIn ? Colors.amber : Colors.green, size: 20,),),)
            ],
          ),
        ),
        /// Error message
        errorMessage.isNotEmpty ? Text(errorMessage) : const SizedBox(),
        ...searchResults.map((e) => TextButton(onPressed: () => selectResult(e), child: Text(e))).toList(),
      ],
    );
  }
}
