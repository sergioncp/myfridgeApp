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

  StreamSubscription<Map<String, dynamic>>? _subscription;

  String dbName = "groceryLists";


  void initState(){
    super.initState();

    _subscription = db.collection(dbName).stream.listen((event) {

      setState(() {
        String title = event['title'];
        print(event);
        groceryLists.add(ListTile(title: Text(title), onTap: (){  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroceryList(listItems: event['items'], id: event['id'], title: event['title'])),
        );},));
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
                        final id = db.collection(dbName).doc().id;

                        db.collection(dbName).doc(id).set({
                          'id': id,
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
