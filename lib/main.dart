import 'dart:collection';

import 'package:flutter/material.dart';
import 'calendar_appbar.dart';
import 'dart:math';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  DateTime lastDate = DateTime.now().add(const Duration(days: 2));

  String expiring = 'Nothing Expiring' ;

  Map <String, String> eventBoard = HashMap();

  late List<String> eventList = [];

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

    setState(() {
      expiring = eventList.contains(getDateTimeFormat(value))? "Something is set to Expire" : "Nothing Expiring Today" ;

    });

  }
  String getDateTimeFormat(DateTime date){

    return  date.year.toString() + "-" + (date.month.toString().length == 1 ? "0"+date.month.toString() : date.month.toString()) + "-" + (date.day.toString().length == 1 ? "0"+date.day.toString() : date.day.toString() );
  }
  void createNewEvent(DateTime date){

    setState(() {
      eventBoard.putIfAbsent(getDateTimeFormat(date), () => "test");
      eventList.add(getDateTimeFormat(date));
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
      events: List.generate(eventList.length, (index) => DateTime.parse(eventList[index])),
    );

    

    return Scaffold(
      appBar: appBar,
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(expiring),

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
