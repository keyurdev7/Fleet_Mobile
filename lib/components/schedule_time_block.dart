import 'package:flutter/material.dart';

class ScheduleTimeBlock extends StatelessWidget {

  final String labelText;
  final String status;
  final String timeSlot;

  const ScheduleTimeBlock({Key key, this.labelText, this.status, this.timeSlot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(7.0)
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: status=="1" ? Colors.lightGreenAccent.shade700 : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      labelText,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  timeSlot,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}