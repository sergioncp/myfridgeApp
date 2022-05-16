import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key, required this.listItems, required this.id, required this.title}) : super(key: key);

  final List<dynamic> listItems;
  final String title;
  final String id;

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final db = Localstore.instance;
  String dbName = "groceryLists";

  List<ListTile> items = [];
  List<dynamic> currentItemList = [];
  @override
  void initState() {
    // TODO: implement initState

    currentItemList = widget.listItems;

    widget.listItems.forEach((element) { items.add(ListTile(title: Text(element), onTap: (){

    },));});
    super.initState();
  }

  void updateList(){

    items = [];
    currentItemList.forEach((element) { items.add(ListTile(title: Text(element), onTap: (){


    },));});
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: ListView(
        children: [
          ...items
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {      showDialog(context: context, builder: (BuildContext context){

          TextEditingController newGroupController = TextEditingController();
          return SimpleDialog(
            title: const Text("New Item"),
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
                        currentItemList.add(newGroupController.text);
                        updateList();
                        db.collection(dbName).doc(widget.id).set({
                          'id' : widget.id,
                          'title' : widget.title,
                          'items' : currentItemList

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
    );
  }
}
