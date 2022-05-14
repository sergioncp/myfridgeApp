import 'package:flutter/material.dart';

class GroceryLists extends StatefulWidget {
  const GroceryLists({Key? key}) : super(key: key);

  @override
  _GroceryListsState createState() => _GroceryListsState();
}

class _GroceryListsState extends State<GroceryLists> {

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
                        setState(() {
                          groceryLists.add(ListTile(title: Text(newGroupController.text),));
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
