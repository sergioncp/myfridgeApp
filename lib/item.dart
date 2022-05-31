import 'package:flutter/material.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';
import 'package:lit_relative_date_time/widget/animated_relative_date_time_builder.dart';

class CalendarItem extends StatefulWidget {
  const CalendarItem({
    Key? key,
    required this.date,
    required this.name,
    required this.delete
  }) : super(key: key);

  final date;
  final name;
  final delete;

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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  RelativeDateFormat _relativeDateFormatter = RelativeDateFormat(Locale('us'),);

  @override
  Widget build(BuildContext context) {
    return

      Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPress: (){
          widget.delete(widget.name);
        },
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
      ),
    );
  }
}
