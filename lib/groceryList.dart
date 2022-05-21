import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class GroceryList extends StatefulWidget {
  const GroceryList(
      {Key? key,
      required this.listItems,
      required this.id,
      required this.title})
      : super(key: key);

  final List<dynamic> listItems;
  final String title;
  final String id;

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final db = Localstore.instance;
  String dbName = "groceryLists";

  List<CheckboxListTile> items = [];
  List<dynamic> currentItemList = [];
  List<bool> checkItems = [];

  @override
  void initState() {
    currentItemList = widget.listItems;

    widget.listItems.forEach((element) {
      String title = element;
      final checked = title.split('/');

      checkItems.add(checked[1] == 'true');
    });
    super.initState();
  }

  void deleteItem(String id) {
    currentItemList.remove(id);
    updateList();
  }

  void updateList() {
    db.collection(dbName).doc(widget.id).set(
        {'id': widget.id, 'title': widget.title, 'items': currentItemList});

    checkItems = [];
    items = [];

    currentItemList.forEach((element) {
      String title = element;
      final checked = title.split('/');

      checkItems.add(checked[1] == 'true');
    });
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
          itemCount: widget.listItems.length,
          itemBuilder: (context, index) {
            String title = widget.listItems[index];
            final checked = title.split('/');
            print(checked);
            return CheckboxListTile(
                title: Text(checked[0]),
                value: checkItems[index],
                onChanged: (bool? value) {
                  setState(() {
                    checkItems[index] = !checkItems[index];
                    currentItemList[index] =
                        checked[0] + "/" + (value).toString();
                    updateList();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                secondary: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteItem(widget.listItems[index]);
                  },
                ));
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController newGroupController =
                    TextEditingController();
                return SimpleDialog(
                  title: const Text("New Item"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: newGroupController,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          //checkItems.add(false);
                          currentItemList
                              .add(newGroupController.text + "/false");
                          updateList();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Create"),
                      )
                    ])
                  ],
                );
              });
        },
      ),
    );
  }
}
