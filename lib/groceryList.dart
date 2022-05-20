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

    currentItemList = widget.listItems;

    widget.listItems.forEach((element) {
      checkItems.add(false);
    });
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
      int myvalue = index;
      checkItems.add(false);
      items.add(
          CheckboxListTile(title: Text(element), value: checkItems[myvalue], onChanged: (bool? value) { setState(() {
            checkItems[myvalue] = !checkItems[myvalue];
            print(checkItems[myvalue]);
          });}, controlAffinity: ListTileControlAffinity.leading, secondary: IconButton(icon: Icon(Icons.delete), onPressed: (){
            deleteItem(element);
          },),)

    );
      index++;
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: ListView.builder(itemCount: widget.listItems.length,itemBuilder: (context, index){

        return CheckboxListTile(title:Text(widget.listItems[index]) , value: checkItems[index], onChanged: (bool? value) { setState(() {
          checkItems[index] = !checkItems[index]; print(checkItems[index]);
        });}, controlAffinity: ListTileControlAffinity.leading, secondary: IconButton(icon: Icon(Icons.delete), onPressed: (){
          deleteItem(widget.listItems[index]);
        },));
      }),
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
