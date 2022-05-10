import 'package:flutter/material.dart';

class CalendarItem extends StatefulWidget {
  const CalendarItem({Key? key, required this.date, required this.name,}) : super(key: key);

  final date;
  final name;


  @override
  _CalendarItemState createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {


  @override
  Widget build(BuildContext context) {


    return Container(child: Text(widget.name + " Expires: " + widget.date));
  }
}

