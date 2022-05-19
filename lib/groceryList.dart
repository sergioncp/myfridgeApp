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

  List<CheckboxListTile> items = [];
  List<dynamic> currentItemList = [];
  List<bool> checkItems = [];


  @override
  void initState() {
    // TODO: implement initState

    currentItemList = widget.listItems;

    int index = 0;
    widget.listItems.forEach((element) {
      index++;
      checkItems.add(false);

      items.add(
        CheckboxListTile(title: Text(element), value: checkItems[index - 1], onChanged: (bool? value) {  setState(() {
          print(checkItems[index - 1]);
         setState(() {
           checkItems[index - 1] = value!;
         });
        });}, controlAffinity: ListTileControlAffinity.leading, secondary: IconButton(icon: Icon(Icons.delete), onPressed: (){
          deleteItem(element);
        },),)

    );});
    super.initState();
  }

  void deleteItem(String id){
    currentItemList.remove(id);
    updateList();
  }

  void updateList(){

    db.collection(dbName).doc(widget.id).set({
      'id' : widget.id,
      'title' : widget.title,
      'items' : currentItemList

    });

    items = [];
    int index = 0;
    currentItemList.forEach((element) {
      index++;
      checkItems.add(false);
      items.add(
        CheckboxListTile(title: Text(element), value: checkItems[index - 1], onChanged: (bool? value) {  setState(() {
          print(checkItems[index - 1]);
          setState(() {
            checkItems[index - 1] = value!;
          });
        });}, controlAffinity: ListTileControlAffinity.leading, secondary: IconButton(icon: Icon(Icons.delete), onPressed: (){
          deleteItem(element);
        },),)

    );});
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
