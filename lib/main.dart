import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:myfridge/groceryLists.dart';
import 'package:myfridge/new_item.dart';
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
      initialRoute: '/',
      routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const MyHomePage(title: "MyFridge"),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/new': (context) => const AddNewItem(),
          '/grocery' : (context) => const GroceryLists(),
        },
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

  final db = Localstore.instance;
  String dbName = "groceryLists";

  DateTime? selectedDate;

  DateTime firstDate = DateTime.now().subtract(const Duration(days: 10));
  DateTime lastDate = DateTime.now().add(const Duration(days: 100));

  String expiring = 'Nothing Expiring' ;

  List<String> eventBoard = [];

  List<Widget> itemsOnScreen = [];

  late List<CalendarItem> eventList = [];


  void onDateChanged(DateTime value){

    itemsOnScreen = [];
    setState(() {

      var it = eventList.iterator;

      while(it.moveNext()){
        CalendarItem item = it.current;

        if(item.date == getDateTimeFormat(value)){
          print(item);
          itemsOnScreen.add(item);
        }
      }
      if(itemsOnScreen.length == 0){
        itemsOnScreen.add(const Center(child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("No Items Expiring"),
        )));
      }
    });



  }
  String getDateTimeFormat(DateTime date){

    return  date.year.toString() + "-" + (date.month.toString().length == 1 ? "0"+date.month.toString() : date.month.toString()) + "-" + (date.day.toString().length == 1 ? "0"+date.day.toString() : date.day.toString() );
  }

  void createNewEvent(DateTime date, String itemName){

    setState(() {
      eventBoard.add(getDateTimeFormat(date));
      eventList.add(CalendarItem(date: getDateTimeFormat(date), name: itemName,));
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    CalendarAppBar appBar = CalendarAppBar(
      backButton: true,
      backButtonCallback: (){ _scaffoldKey.currentState!.openDrawer();},
      onDateChanged: (value) => onDateChanged(value),
      firstDate: firstDate,
      selectedDate: DateTime.now(),
      lastDate: lastDate,
      events: List.generate(eventBoard.length, (index) => DateTime.parse(eventBoard[index])),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('My Fridge'),
            ),
            ListTile(
              title: const Text('Calendar'),
              onTap: () {
                if(ModalRoute.of(context)?.settings.name == '/'){
                  Navigator.pop(context);
                }

              },
            ),
            ListTile(
              title: const Text('Grocery Lists'),
              onTap: () {
                Navigator.pushNamed(context, '/grocery');
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...itemsOnScreen,

        ],
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
            onTap: () => Navigator.pushNamed(context, '/new', arguments: createNewEvent)
          )
        ]
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
