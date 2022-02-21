import 'package:builder/builder/models/page_data.dart';
import 'package:builder/builder/models/tabItemData.dart';
import 'package:builder/builder/state/builder_provider.dart';
import 'package:builder/builder/state/functions_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

List<Widget> functions(BuilderProvider state, FunctionsProvider functionsState) {
  return [
    _addPage(state, functionsState),
  ];
}

Widget _addPage(BuilderProvider state, FunctionsProvider functionsState) {
  var uuid = Uuid();

  var pages = state.getPages;

  Widget pageTile(TabItemData item) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(item.name),
          IconButton(
              onPressed: () => state.deletePage(item.id),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ]),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            var txt = functionsState.newPageText;
            var id = uuid.v4();
            var page = PageData(
                dataClass: txt,
                id: id,
                tabItemData: TabItemData(
                  id: id,
                  name: txt,
                  icon: "",
                ));
            state.addPage(page);
          },
          child: Text('Add New Page'),
        ),
        TextField(
          onChanged: (value) => functionsState.setNewPageText(value),
        ),
        SizedBox(
          height: 22,
        ),
        Text("Current Pages"),
        ...pages.map((e) => pageTile(e.tabItemData)).toList(),
      ],
    ),
  );
}
