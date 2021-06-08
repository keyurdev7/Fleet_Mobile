import 'package:fleet_management/model/dataListModel.dart';
import 'package:fleet_management/components/schedule_list.dart';
import 'package:fleet_management/services/services.dart';
import 'package:flutter/material.dart';
import 'package:fleet_management/repository/user_repository.dart' as userRp;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

class DashBoard extends StatefulWidget {
  static String id = "/SplashScreen";

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String selectedDate;
  DateTime startDate, endDate, date;
  bool spinner = false;
  ScheduleListModel scheduleListModel;

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<ScheduleListBlock> blocks = [];
  List<Map<String, dynamic>> dataList = [];
  List<ScheduleData> scheduleDataList = [];

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    getList(date);
  }

  Future getDates(DateTime date) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      getList(picked);
      setState(() {
        selectedDate = months[picked.month - 1] + " " + picked.year.toString();
      });
    }
  }

  void arrowPress(String direction) async {
    if (direction == "back") {
      date = date.subtract(Duration(days: 7));
    } else if (direction == "forward") {
      date = date.add(Duration(days: 7));
    }
    selectedDate = months[date.month - 1] + " " + date.year.toString();
    setState(() {});
    getList(date);
  }

  String arrangeDate(DateTime date) {
    String arrangedDate;
    var day = date.day.toString().length > 1
        ? date.day.toString()
        : "0" + date.day.toString();
    var month = date.month.toString().length > 1
        ? date.month.toString()
        : "0" + date.month.toString();
    arrangedDate = date.year.toString() + "-" + month + "-" + day;
    return arrangedDate;
  }

  Future getList(DateTime date) async {
    blocks.clear();
    scheduleDataList.clear();
    setState(() {
      spinner = true;
    });
    endDate = date.add(Duration(days: (7 - date.weekday)));
    startDate = date.subtract(Duration(days: (date.weekday - 1)));
    String startTime = arrangeDate(startDate);
    String endTime = arrangeDate(endDate);
    print('dashboard>>>' + startTime);
    print('dashboard>>>' + endTime);
    print('dashboard>>>' + userRp.currentUser.value.userId);
    var response =
        await getSchedule(startTime, endTime, userRp.currentUser.value.userId);
    setState(() {
      spinner = false;
    });
    if (response.isNotEmpty) {
      scheduleListModel = ScheduleListModel.fromList(response);
      for (var data in scheduleListModel.scheduleList) {
        scheduleDataList.add(data);
      }
      setState(() {
        for (var data in scheduleDataList) {
          String weekDate = getDateNumberFromDate(data.date);
          String weekDay = getDayFromDate(data.date);
          // var dateString = data.date.split("-");
          // String weekDate = dateString[2].split("T")[0];
          // String weekDay = getWeekDay(startDate, int.parse(weekDate));
          blocks.add(ScheduleListBlock(
            timeSlot: data.beginTime + " - " + data.endTime,
            labelText: data.service,
            day: weekDate,
            weekDay: weekDay,
          ));
        }
      });
      print(blocks);
    }
  }

  // get day from the date
  String getDayFromDate(String date) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    return DateFormat('EEE').format(parseDate);
  }

  // get day from the date
  String getDateNumberFromDate(String date) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    return DateFormat('d').format(parseDate);
  }

  String getWeekDay(DateTime date, int day) {
    int weekDay = day - date.weekday + 1;
    return weekDays[weekDay];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[700], Colors.lightBlueAccent],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            "My Schedule",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_outlined),
                                onPressed: () {
                                  arrowPress("back");
                                },
                                color: Colors.white,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (date != null) {
                                      getDates(date);
                                    } else {
                                      getDates(DateTime.now());
                                    }
                                  }),
                              Text(
                                selectedDate != null && selectedDate != ""
                                    ? selectedDate
                                    : months[DateTime.now().month - 1] +
                                        " " +
                                        DateTime.now().year.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_outlined),
                                onPressed: () {
                                  arrowPress("forward");
                                },
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                elevation: 2.0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: blocks.isNotEmpty
                        ? ListView(
                            children: blocks,
                          )
                        : Center(
                            child: Container(
                              child: Text("No Schedule"),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
