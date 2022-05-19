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

  String daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    int difference = (to.difference(from).inHours / 24).round();
    String relativeDays = "";


    switch(difference){
      case -1:
        relativeDays = "Expired Yesterday";
        break;
      case 0:
        relativeDays = "Expires Today";
        break;
      case 1:
        relativeDays = "Expires Tomorrow";
        break;
      default:
        if(difference < -1){
          relativeDays = "Expired " + (difference * -1).toString() + " Days Ago";
        }else{
          relativeDays = "Expires In " + difference.toString() + " Days";
        }
    }



    return relativeDays;
  }

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
            Text(daysBetween(DateTime.now(), DateTime.parse(widget.date)), style: TextStyle(color: Colors.white),)
          ],
        ),
        decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
