import 'package:flutter/material.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:lit_relative_date_time/widget/animated_relative_date_time_builder.dart';

class CalendarItem extends StatefulWidget {
  const CalendarItem({
    Key? key,
    required this.date,
    required this.name,
  }) : super(key: key);

  final date;
  final name;

  @override
  _CalendarItemState createState() => _CalendarItemState();
}



class _CalendarItemState extends State<CalendarItem> {
  

  RelativeDateFormat _relativeDateFormatter = RelativeDateFormat(Locale('us'),);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.name + " " , style: TextStyle(color: Colors.white),),
            Text(_relativeDateFormatter.format(RelativeDateTime(dateTime: DateTime.now(), other: DateTime.parse(widget.date))), style: TextStyle(color: Colors.white),)
          ],
        ),
        decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
