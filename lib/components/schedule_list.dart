import 'package:fleet_management/components/schedule_time_block.dart';
import 'package:flutter/material.dart';

class ScheduleListBlock extends StatelessWidget {

  final String weekDay;
  final String day;
  final String labelText;
  final String timeSlot;

  const ScheduleListBlock({Key key, this.weekDay, this.day, this.timeSlot,this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Expanded(
            flex: 1,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      weekDay,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      day,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ScheduleTimeBlock(
                labelText: labelText,
                timeSlot: timeSlot,
                status: "2",
              ),
            ),
          ),
        ],
      ),
    );
  }
}