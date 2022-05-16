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
  @override
  void initState() {
    // TODO: implement initState

    widget.listItems.forEach((element) { items.add(ListTile(title: Text(element), onTap: (){
      db.collection(dbName).doc(widget.id).set({
        'id' : widget.id,
        'title' : widget.title,
        'items' : ["1", "2", "3"]

      });
      updateList(["1", "2", "3"]);

    },));});
    super.initState();
  }

  void updateList(List<dynamic> myList){

    items = [];
    myList.forEach((element) { items.add(ListTile(title: Text(element), onTap: (){
      db.collection(dbName).doc(widget.id).set({
        'id' : widget.id,
        'title' : widget.title,
        'items' : ["1", "2", "3"]

      });


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
    );
  }
}
