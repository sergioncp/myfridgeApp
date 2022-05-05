import 'dart:collection';

import 'package:flutter/material.dart';
import 'calendar_appbar.dart';
import 'dart:math';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Fridge',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MyFridge'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateTime? selectedDate;

  DateTime firstDate = DateTime.now().subtract(const Duration(days: 10));
  DateTime lastDate = DateTime.now().add(const Duration(days: 100));

  String expiring = 'Nothing Expiring' ;

  List<String> eventBoard = [];

  List<CalendarItem> itemsOnScreen = [];

  late List<CalendarItem> eventList = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      createNewEvent(picked);
    }
  }

  void onDateChanged(DateTime value){

    itemsOnScreen = [];
    setState(() {

      var it = eventList.iterator;

      while(it.moveNext()){
        CalendarItem item = it.current;

        if(item.date == getDateTimeFormat(value)){
          itemsOnScreen.add(item);
        }
      }
      if(itemsOnScreen.length == 0){
        itemsOnScreen.add(new CalendarItem(date: "No Items Expiring Today", name: "Nothing"));
      }
    });



  }
  String getDateTimeFormat(DateTime date){

    return  date.year.toString() + "-" + (date.month.toString().length == 1 ? "0"+date.month.toString() : date.month.toString()) + "-" + (date.day.toString().length == 1 ? "0"+date.day.toString() : date.day.toString() );
  }
  void createNewEvent(DateTime date){

    setState(() {
      eventBoard.add(getDateTimeFormat(date));
      eventList.add(CalendarItem(date: getDateTimeFormat(date), name: "test",));
    });

  }
  Future<void> scanBarcode() async {

    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666","Cancel",false,ScanMode.BARCODE);

    print(barcodeScanRes);
  }

  void updateAppBar(CalendarAppBar bar){

  }

  @override
  void initState() {
    setState(() {
      selectedDate = DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    CalendarAppBar appBar = CalendarAppBar(
      backButton: false,
      onDateChanged: (value) => onDateChanged(value),
      firstDate: firstDate,
      selectedDate: DateTime.now(),
      lastDate: lastDate,
      events: List.generate(eventBoard.length, (index) => DateTime.parse(eventBoard[index])),
    );

    return Scaffold(
      appBar: appBar,
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...itemsOnScreen,

          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 5,
        spaceBetweenChildren: 5,
        renderOverlay: false,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.photo_camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onTap: () => scanBarcode(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onTap: () => _selectDate(context)
          )
        ]
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
