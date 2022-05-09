import 'package:flutter/material.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({Key? key}) : super(key: key);

  @override
  _AddNewItemState createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  @override

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      print(picked);
      //createNewEvent(picked);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("Add Item"),),
      body:Column(
        children: [
          Text("New Item Name"),
          TextField(),
          //Text('Pick Item Date'),
          ElevatedButton(onPressed: ()=>{ _selectDate(context)} , child: Text("Pick Date"))
        ],
      ),

    );
  }
}
