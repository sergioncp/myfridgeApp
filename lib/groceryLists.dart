import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class GroceryLists extends StatefulWidget {
  const GroceryLists({Key? key}) : super(key: key);

  @override
  _GroceryListsState createState() => _GroceryListsState();
}

class _GroceryListsState extends State<GroceryLists> {

  final db = Localstore.instance;

  //final _items = <String, Todo>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  Future<void> getLists() async {
    //groceryLists = [];
    final items = await db.collection('lists').get();

    items?.forEach((key, value) {
      String title = value['title'];
      print(title);
      groceryLists.add(ListTile(title: Text(title),));
    });
    //print(items);
  }

  void initState(){
    super.initState();

    _subscription = db.collection('lists').stream.listen((event) {
      setState(() {

        String title = event['title'];
        print(title);
        groceryLists.add(ListTile(title: Text(title),));
      });
    });

  }

  List<ListTile> groceryLists = [];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery Lists"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {      showDialog(context: context, builder: (BuildContext context){

          TextEditingController newGroupController = TextEditingController();
          return SimpleDialog(
            title: const Text("New Grocery List"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField( controller: newGroupController,),
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
                        final id = db.collection('todos').doc().id;

                        db.collection('lists').doc(id).set({
                          'title': newGroupController.text,
                          'items': ["1"]
                        });


                        Navigator.of(context).pop();
                      },
                      child: const Text("Create"),
                    )
                  ])
            ],
          );
        });},

      ),
      body: ListView(
        children: [...groceryLists],
      ),
    );
  }
}
