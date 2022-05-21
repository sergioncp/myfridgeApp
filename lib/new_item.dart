import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({Key? key}) : super(key: key);


  @override
  _AddNewItemState createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  @override

  final f = new DateFormat('yyyy-MM-dd');

  DateTime datePicked = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController itemNameController = TextEditingController();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {

      setState(() {
        datePicked = picked;
      });

      //print(picked);
      //createNewEvent(picked);
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
        datePicked = DateTime(datePicked.year, datePicked.month, datePicked.day, timeOfDay.hour, timeOfDay.minute);
        print(datePicked);

      });
    }
  }


  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    Function createNew = arg['createNewEventFunction'];
    String itemName = arg['itemName'];

    if(itemName != 'none'){
      itemNameController.text = itemName;
    }



    final localizations = MaterialLocalizations.of(context);
    final formattedTimeOfDay = localizations.formatTimeOfDay(selectedTime);


    return Scaffold(
      appBar: AppBar(title: new Text("Add Item"),),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Item Name", style: TextStyle(fontSize: 25),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(controller: itemNameController,),
          ),
          //Text('Pick Item Date'),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: ()=>{ _selectDate(context)} , child: Text("Pick a Date")),
                Text(DateFormat.yMMMMEEEEd().format(datePicked), style: TextStyle(fontSize: 20),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: ()=>{ _selectTime(context)} , child: Text("Pick a Time")),
                Text(formattedTimeOfDay, style: TextStyle(fontSize: 20),),
              ],
            ),
          ),
          ElevatedButton(onPressed: (){ createNew(datePicked, itemNameController.text); Navigator.pop(context);}, child: Text("Add Item"))
        ],
      ),

    );
  }
}
