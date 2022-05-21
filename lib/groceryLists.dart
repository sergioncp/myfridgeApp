import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:myfridge/groceryList.dart';

class GroceryLists extends StatefulWidget {
  const GroceryLists({Key? key}) : super(key: key);

  @override
  _GroceryListsState createState() => _GroceryListsState();
}

class _GroceryListsState extends State<GroceryLists> {

  final db = Localstore.instance;
  String dbName = "groceryLists";

  StreamSubscription<Map<String, dynamic>>? _subscription;


  void initState() {
    super.initState();
  }

  List<ListTile> groceryLists = [];

  FutureBuilder<Map<String, dynamic>?> getItems() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: db.collection(dbName).get(),
      // a previously-obtained Future<String> or null
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        List<dynamic> itemList = [];

        if (snapshot.hasData) {
          print(snapshot.data);
          snapshot.data?.forEach((key, value) {
            itemList.add(value);
          });
          print(itemList);
        } else if (snapshot.hasError) {
          print("There has been an error");
        } else {

        }


        return ListView.builder(
            itemCount: itemList.length, itemBuilder: (context, index) {
          dynamic event = itemList[index];
          return ListTile(title: Text(event['title']), onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  GroceryList(listItems: event['items'],
                      id: event['id'],
                      title: event['title'])),
            );
          }, trailing:IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              db.collection(dbName).doc(event['id']).delete();
              setState(() {

              });
              print("delete this");
              //deleteItem(widget.listItems[index]);
            },
          ),);
        }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery Lists"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            TextEditingController newGroupController = TextEditingController();
            return SimpleDialog(
              title: const Text("New Grocery List"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(controller: newGroupController,),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          final id = db
                              .collection(dbName)
                              .doc()
                              .id;

                          db.collection(dbName).doc(id).set({
                            'id': id,
                            'title': newGroupController.text,
                            'items': []
                          });


                          Navigator.of(context).pop();
                          setState(() {

                          });
                        },
                        child: const Text("Create"),
                      )
                    ])
              ],
            );
          });
        },

      ),
      body: getItems(),

      //ListView(
      //children: [...groceryLists],
      //),
    );
  }
}
